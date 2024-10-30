import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'user_map_event.dart';
part 'user_map_state.dart';

class UserMapBloc extends Bloc<UserMapEvent, UserMapState> {
  Geolocator location = Geolocator();
  late CameraPosition cameraPosition;
  late Position currentLocationPosition;
  UserMapBloc() : super(UserMapInitial()) {
    on<FetchCurrentLocation>((event, emit) async {
      emit(UserMapLoadingState());
      try {
        LocationPermission isPermissionEnable =
            await Geolocator.checkPermission();
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (isPermissionEnable == LocationPermission.always ||
            isPermissionEnable == LocationPermission.whileInUse) {
          log("message $serviceEnabled");

          currentLocationPosition = await Geolocator.getCurrentPosition();
          log("latitude ${currentLocationPosition.latitude}==== longitude ${currentLocationPosition.longitude}");

          List<gc.Placemark> placemark = await gc.placemarkFromCoordinates(
              currentLocationPosition.latitude,
              currentLocationPosition.longitude);
          cameraPosition = CameraPosition(
            target: LatLng(currentLocationPosition.latitude,
                currentLocationPosition.longitude),
            zoom: 14.4746,
          );
          emit(UpdateMapState());
        } else {
          await Geolocator.requestPermission();
        }
      } catch (error) {
        log("error $error");
      }
    });
  }
}
