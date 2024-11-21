import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/user_request_model.dart';
import 'package:taxi_finder/repositories/driver_map_repo.dart';

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
        await acceptRequest(event.userRequestModel.uid ?? "");
        await updateRideRequestedDoc(
            docId: event.userRequestModel.uid ?? "",
            status: FirebaseStrings.accepted);
            
        emit(RideAcceptedState());
      },
    );
  }
}
