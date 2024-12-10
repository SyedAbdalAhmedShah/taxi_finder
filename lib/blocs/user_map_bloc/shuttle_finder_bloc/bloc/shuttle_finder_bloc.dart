import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/repositories/shuttle_finder_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'shuttle_finder_event.dart';
part 'shuttle_finder_state.dart';

class ShuttleFinderBloc extends Bloc<ShuttleFinderEvent, ShuttleFinderState>
    with ShuttleFinderRepo {
  bool pickMeUpFromMyLocation = false;
  List<DriverInfo> nearByDrivers = [];
  Set<Marker> nearByDriverMarker = {};
  late Stream<List<DriverInfo>> nearByDriversStream;
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
          nearByDriversStream = getNearByShuttleFinderDrivers(currentLatLong);
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

    on<OnNearByShuttleDriversAddedEvent>((event, emit) async {
      try {
        final updatedMarkers = <Marker>{};
        final currentDriverIds = event.availableDrivers
            .map((driver) => driver.driverUid ?? "")
            .toSet();

        var icon = await BitmapDescriptor.asset(
          const ImageConfiguration(devicePixelRatio: 1.2, size: Size(50, 50)),
          vanImage,
        );
        nearByDrivers = event.availableDrivers;
        for (final driver in event.availableDrivers) {
          Marker driverMarker = Marker(
              markerId: MarkerId(driver.driverUid ?? ""),
              position: LatLng(driver.latLong?.geoPoint?.latitude ?? 0.0,
                  driver.latLong?.geoPoint?.longitude ?? 0.0),
              icon: icon);
          updatedMarkers.add(driverMarker);
          nearByDriverMarker.removeWhere(
              (marker) => !currentDriverIds.contains(marker.markerId.value));
        }
        nearByDriverMarker = updatedMarkers;
        log('marker length ${updatedMarkers.length}');
        emit(OnShuttleNearByDriversAddedState());
      } catch (e) {
        log('error is $e');
      }
    });
  }
}
