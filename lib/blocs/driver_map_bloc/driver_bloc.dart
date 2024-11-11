import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/repositories/driver_map_repo.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> with DriverMapRepo {
  late GoogleMapController mapController;
  List<>
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
        log('ERROR IS $Error HAPPENED IN DRIVER BLOC ',
            name: "DriverCurrentLocationEvent");
        emit(DriverMapFailureState());
      }
    });

on<OnRideRequestRecieveEvent>((event, emit) {
  
},);

  }
}
