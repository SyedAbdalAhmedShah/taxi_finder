import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/ride_request_model.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/models/user_request_model.dart';
import 'package:taxi_finder/repositories/driver_map_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> with DriverMapRepo {
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
  late UserRequestModel currentRideRequest;
  DriverBloc() : super(DriverInitial()) {
    on<DriverCurrentLocationEvent>((event, emit) async {
      emit(DriverMapLoadingState());
      try {
        LocationPermission isPermissionEnable =
            await Geolocator.checkPermission();
        if (isPermissionEnable == LocationPermission.always ||
            isPermissionEnable == LocationPermission.whileInUse) {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            positionStream = getPositionListner();

            driverCurrentPosition = await Geolocator.getCurrentPosition();
            await updateDriverLocation(driverCurrentPosition);
            cameraPosition = CameraPosition(
              target: LatLng(driverCurrentPosition.latitude,
                  driverCurrentPosition.longitude),
              zoom: 16.4746,
            );
            mapController
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

            emit(DriverCurrentLocationUpdatedState());
          } else {
            Geolocator.requestPermission();
          }
        } else {
          await Geolocator.requestPermission();
        }
      } catch (error) {
        log('ERROR IS $error HAPPENED IN DRIVER BLOC ',
            name: "DriverCurrentLocationEvent");
        emit(DriverMapFailureState());
      }
    });
    on<OnRequestExpireEvent>(
      (event, emit) async {
        await updateRideRequestedDoc(
            docId: event.docId, status: FirebaseStrings.expired);

        emit(ExpiredRequestState());
      },
    );
    on<OnAcceptRide>(
      (event, emit) async {
        await acceptRequestAndUpdateDriverColl(
            event.userRequestModel.requestId ?? "");
        await updateRideRequestedDoc(
            docId: event.userRequestModel.requestId ?? "",
            status: FirebaseStrings.accepted);
        currentRideRequest = event.userRequestModel;
        LatLng userPickupPoint = LatLng(
            event.userRequestModel.userPickUpLocation?.geoPoint?.latitude ??
                0.0,
            event.userRequestModel.userPickUpLocation?.geoPoint?.longitude ??
                0.0);
        Polyline polyline;
        Marker destinationMarker;
        String totalDistance;

        (totalDistance, polyline, destinationMarker) =
            await Utils.getPolyLinesAndMarker(
                currentLocationPosition: driverCurrentPosition,
                destLocationPosition: userPickupPoint);
        polylineSet.add(polyline);
        markers.add(destinationMarker);
        emit(RideAcceptedState());
      },
    );

    on<OnUserPickupLocationReached>((event, emit) async {
      emit(DriverMapLoadingState());
      try {
        String userId = currentRideRequest.userUid ?? "";
        UserModel? userModel = await Utils.getUserData(uid: userId);
        if (userModel != null) {
        } else {
          log('user is null');
          emit(DriverMapFailureState());
        }
      } catch (e) {
        log('error happened in OnUserPickupLocationReached $e',
            name: "Driver bloc");
        emit(DriverMapFailureState());
      }
    });
  }
}
