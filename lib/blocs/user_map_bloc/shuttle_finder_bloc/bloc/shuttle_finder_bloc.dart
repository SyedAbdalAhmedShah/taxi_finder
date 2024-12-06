import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'shuttle_finder_event.dart';
part 'shuttle_finder_state.dart';

class ShuttleFinderBloc extends Bloc<ShuttleFinderEvent, ShuttleFinderState> {
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
          currentUserLocation = await Geolocator.getCurrentPosition();
          LatLng currentLatLong = LatLng(
              currentUserLocation.latitude, currentUserLocation.longitude);
          GeoPoint currentGeoPoint =
              GeoPoint(currentLatLong.latitude, currentLatLong.longitude);
          final placeMarkers =
              await Utils.getFullStringAddress(currentGeoPoint);
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
        emit(ShuttleFinderFailureState());
      }
    });
  }
}
