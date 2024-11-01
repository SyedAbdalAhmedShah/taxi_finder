import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/utils/api_keys.dart';

part 'user_map_event.dart';
part 'user_map_state.dart';

class UserMapBloc extends Bloc<UserMapEvent, UserMapState> {
  Geolocator location = Geolocator();
  TextEditingController myLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String countryISO = "PK";
  FocusNode destinationFocusNode = FocusNode();
  PolylinePoints polylinePoints = PolylinePoints();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late Position currentLocationPosition;
  Set<Polyline> polylineSet = {};

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

          List<gc.Placemark> placemarks = await gc.GeocodingPlatform.instance!
              .placemarkFromCoordinates(currentLocationPosition.latitude,
                  currentLocationPosition.longitude);
          gc.Placemark placemark = placemarks.first;
          String address =
              "${placemark.street ?? ""}${placemark.subLocality ?? ""} ${placemark.locality ?? ""} ${placemark.administrativeArea ?? ""} ${placemark.country ?? ""}";
          countryISO = placemark.isoCountryCode ?? countryISO;

          myLocationController.text = address;
          cameraPosition = CameraPosition(
            target: LatLng(currentLocationPosition.latitude,
                currentLocationPosition.longitude),
            zoom: 15.4746,
          );
          emit(UpdateMapState());
        } else {
          await Geolocator.requestPermission();
        }
      } catch (error) {
        log("error $error");
      }
    });
    on<OnDirectionEvent>(
      (event, emit) async {
        List<LatLng> _routeCoords = [];
        PointLatLng currentLocPoint = PointLatLng(
            currentLocationPosition.latitude,
            currentLocationPosition.longitude);
        PointLatLng destinationLocPoint =
            PointLatLng(event.latLng.latitude, event.latLng.longitude);
        // LatLng currentLatLong = LatLng(currentLocationPosition.latitude,
        //     currentLocationPosition.longitude);
        // LatLng destinationLatLong =
        //     LatLng(event.latLng.latitude, event.latLng.longitude);
        try {
          PolylineResult points =
              await polylinePoints.getRouteBetweenCoordinates(
                  googleApiKey: ApiKeys().placesApiKey,
                  request: PolylineRequest(
                      origin: currentLocPoint,
                      destination: destinationLocPoint,
                      mode: TravelMode.driving));
          log("Direction ${points.distanceValues}", name: "polypoint");
          if (points.points.isNotEmpty) {
            _routeCoords = points.points
                .map((p) => LatLng(p.latitude, p.longitude))
                .toList();
          } else {
            log('Error: ${points.errorMessage}');
          }
          Polyline polyline = Polyline(
            polylineId: const PolylineId("Direction Route 1"),
            points: _routeCoords,
            color: secondaryColor,
          );
          polylineSet.add(polyline);
          // log("polyline ${polyline.points.toString()}");
          emit(OnDirectionRequestState());
        } catch (error) {
          log("error $error", name: "OnDirectionEvent");
        }
      },
    );
  }
}
