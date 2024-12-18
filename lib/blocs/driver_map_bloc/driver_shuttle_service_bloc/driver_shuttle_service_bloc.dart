import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/shuttle_ride_request.dart';

import 'package:taxi_finder/models/user_request_model.dart';
import 'package:taxi_finder/repositories/driver_map_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'driver_shuttle_service_event.dart';
part 'driver_shuttle_service_state.dart';

class DriverShuttleServiceBloc
    extends Bloc<DriverShuttleServiceEvent, DriverShuttleServiceState>
    with DriverMapRepo {
  late GoogleMapController mapController;
  late List<UserRequestModel> userRequest;
  StreamSubscription<Position>? positionStream;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late Position driverCurrentPosition;
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  DriverShuttleServiceBloc() : super(DriverShuttleServiceInitial()) {
    on<DriverCurrentLocationEvent>((event, emit) async {
      emit(DriverShuttleServiceLoadingState());
      try {
        bool isPermisssionGranted = await Utils.isPermissionGranted();
        if (isPermisssionGranted) {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            driverCurrentPosition = await Geolocator.getCurrentPosition();
            await updateDriverLocation(driverCurrentPosition);
            cameraPosition = CameraPosition(
              target: LatLng(driverCurrentPosition.latitude,
                  driverCurrentPosition.longitude),
              zoom: 16.4746,
            );
            mapController
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            positionStream = Utils.getPositionListner();
            emit(ShuttleDriverCurrentLocationState());
          } else {
            add(DriverCurrentLocationEvent());
          }
        } else {
          add(DriverCurrentLocationEvent());
        }
      } catch (e) {
        log('error happened $e');
        emit(DriverShuttleServiceFailureState());
      }
    });

    on<OnExpireShuttleRideRequest>((event, emit) async {
      try {
        await updateDriverShuttleRideRequest(
            docId: event.requestId, status: FirebaseStrings.expired);
      } catch (e) {
        emit(DriverShuttleServiceFailureState());
      }
    });
    on<OnShuttleRideAcceptEvent>((event, emit) async {
      try {
        emit(DriverShuttleRideAcceptLoadingState());
        ShuttleRideRequest shuttleRideRequest = event.shuttleRideRequest;
        await acceptShuttleRequestAndUpdateDriverColl(
            shuttleRideRequest.requestId ?? "");
        await updateActiveRideOfUserForShuttleRide(
            userId: shuttleRideRequest.userId ?? "",
            requestId: shuttleRideRequest.requestId ?? "");
        var icon = await BitmapDescriptor.asset(
          const ImageConfiguration(devicePixelRatio: 1.2, size: Size(50, 50)),
          userMarkerForDriver,
        );
        LatLng userLocation = LatLng(
          shuttleRideRequest.userPickUpLocation?.geoPoint?.latitude ?? 0.0,
          shuttleRideRequest.userPickUpLocation?.geoPoint?.longitude ?? 0.0,
        );
        Marker acceptedUserLocationMarker = Marker(
            markerId: MarkerId("${shuttleRideRequest.requestId}"),
            position: userLocation,
            icon: icon);
        DriverInfo? driverInfo = await Utils.driver(
            driverUid: loggedRole.driverInfo.driverUid ?? "");

        markers.add(acceptedUserLocationMarker);
        emit(OnShuttleRideAcceptedState());
      } catch (e) {
        log("error $e");
        emit(DriverShuttleServiceFailureState());
      }
    });
  }
}
