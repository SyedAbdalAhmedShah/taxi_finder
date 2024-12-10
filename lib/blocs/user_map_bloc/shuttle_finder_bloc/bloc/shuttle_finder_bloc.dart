import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/repositories/shuttle_finder_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'shuttle_finder_event.dart';
part 'shuttle_finder_state.dart';

class ShuttleFinderBloc extends Bloc<ShuttleFinderEvent, ShuttleFinderState>
    with ShuttleFinderRepo {
  bool pickMeUpFromMyLocation = false;
  late GoogleMapController googleMapController;
  late Position currentUserLocation;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  ShuttleFinderBloc() : super(ShuttleFinderInitial()) {
    on<GetUserCurrentLocation>((event, emit) async {
      try {
        emit(ShuttleFinderLoadingState());
        bool isPermissionGranted = await Utils.isPermissionGranted();
        if (isPermissionGranted) {
          bool isLocationServiceEnable =
              await Geolocator.isLocationServiceEnabled();
          log('isLocationServiceEnable $isLocationServiceEnable');
          currentUserLocation = await Geolocator.getCurrentPosition();
          LatLng currentLatLong = LatLng(
              currentUserLocation.latitude, currentUserLocation.longitude);

          cameraPosition = CameraPosition(
            target: currentLatLong,
            zoom: 16.4746,
          );
          await googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          emit(ShuttleFinderCurrentUserLocationState());
        } else {
          await Geolocator.requestPermission();
          add(GetUserCurrentLocation());
        }
      } catch (e) {
        log('error $e');
        emit(ShuttleFinderFailureState());
      }
    });

    on<OnShuttleSelectLocation>((event, emit) => emit(
          OnShuttleLocationSelectedState(selectedCity: event.selectedCity),
        ));

    on<PickMeUpFromMyLocationByUser>((event, emit) {
      pickMeUpFromMyLocation = !pickMeUpFromMyLocation;
      emit(TooglePickMeUpFromMyLocationState());
    });
  }
}
