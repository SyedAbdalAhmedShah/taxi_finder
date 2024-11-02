import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/models/auto_complete_model.dart';
import 'package:taxi_finder/repositories/user_map_repo.dart';
import 'package:taxi_finder/utils/api_helper.dart';

part 'user_map_event.dart';
part 'user_map_state.dart';

class UserMapBloc extends Bloc<UserMapEvent, UserMapState> {
  UserMapRepo userMapRepo = UserMapRepo();

  Geolocator location = Geolocator();
  TextEditingController myLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? countryISO;
  FocusNode destinationFocusNode = FocusNode();
  PolylinePoints polylinePoints = PolylinePoints();
  List<Prediction> searchLocations = [];
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late Position currentLocationPosition;

  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};

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
        List<LatLng> routeCoords = [];
        PointLatLng currentLocPoint = PointLatLng(
            currentLocationPosition.latitude,
            currentLocationPosition.longitude);
        PointLatLng destinationLocPoint =
            PointLatLng(event.latLng.latitude, event.latLng.longitude);

        try {
          PolylineResult points =
              await polylinePoints.getRouteBetweenCoordinates(
                  googleApiKey: ApiHelper().placesApiKey,
                  request: PolylineRequest(
                      origin: currentLocPoint,
                      destination: destinationLocPoint,
                      mode: TravelMode.driving));

          if (points.points.isNotEmpty) {
            routeCoords = points.points
                .map((p) => LatLng(p.latitude, p.longitude))
                .toList();
          } else {
            log('Error: ${points.errorMessage}');
          }
          log("distance ${(points.distanceTexts)}");
          Polyline polyline = Polyline(
            polylineId: const PolylineId("Direction Route 1"),
            points: routeCoords,
            color: secondaryColor,
          );

          polylineSet.add(polyline);
          Marker destinationMarker = Marker(
              markerId: const MarkerId("destination"),
              infoWindow: InfoWindow(title: "${points.endAddress}"),
              position:
                  LatLng(routeCoords.last.latitude, routeCoords.last.longitude),
              visible: true);
          markers.add(destinationMarker);
          emit(OnDirectionRequestState());
        } catch (error) {
          log("error $error", name: "OnDirectionEvent");
        }
      },
    );
    on<OnLocationSearchEvent>(
      (event, emit) async {
        destinationController.text = event.query;
        searchLocations = await userMapRepo.getPlacesSuggestion(
            query: event.query, countryISO: countryISO ?? "PK");
        
        emit(OnLocationSearchState());
      },
    );
  }
}
