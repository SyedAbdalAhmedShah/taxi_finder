import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/models/auto_complete_model.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/place_detail_model.dart';
import 'package:taxi_finder/repositories/user_map_repo.dart';

part 'user_map_event.dart';
part 'user_map_state.dart';

class UserMapBloc extends Bloc<UserMapEvent, UserMapState> {
  UserMapRepo userMapRepo = UserMapRepo();
  late Stream<List<DriverInfo>> nearByDriversStream;
  Set<Marker> nearByDriverMarker = {};
  Geolocator location = Geolocator();
  TextEditingController myLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? countryISO;
  FocusNode destinationFocusNode = FocusNode();
  String totalLocationDistance = "";
  String totalfare = "";
  bool showRequestSheet = false;
  TextEditingController totalSeatBookController = TextEditingController();
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

        if (isPermissionEnable == LocationPermission.always ||
            isPermissionEnable == LocationPermission.whileInUse) {
          currentLocationPosition = await Geolocator.getCurrentPosition();
          nearByDriversStream =
              userMapRepo.getNearByDrivers(currentLocationPosition);
          final placeMarkers =
              await userMapRepo.getFullStringAddress(currentLocationPosition);
          countryISO = placeMarkers.$2;
          destinationController.text = placeMarkers.$1;
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
        try {
          Polyline polyline;
          Marker destinationMarker;
          String totalDistance;
          (totalDistance, polyline, destinationMarker) =
              await userMapRepo.getPolyLinesAndMarker(
                  currentLocationPosition: currentLocationPosition,
                  destLocationPosition: event.latLng);
          totalLocationDistance = totalDistance;

          totalfare =
              userMapRepo.getTotalFare(totalLocationDistance).toString();
          polylineSet.add(polyline);
          cameraPosition = CameraPosition(
              target: LatLng(currentLocationPosition.latitude,
                  currentLocationPosition.longitude),
              zoom: 10.0);
          markers.add(destinationMarker);
          emit(OnDirectionRequestState());
        } catch (error) {
          log("error $error", name: "OnDirectionEvent");
          emit(UserMapFailureState(errorMessage: routeNotFount));
        }
      },
    );
    on<OnLocationSearchEvent>((event, emit) async {
      destinationController.text = event.query;
      searchLocations = await userMapRepo.getPlacesSuggestion(
          query: event.query, countryISO: countryISO ?? "PK");

      emit(OnLocationSearchState());
    });
    on<OnLocationSelectedEvent>(
      (event, emit) async {
        try {
          PlacesDetail placesDetail = await userMapRepo
              .getPlaceDetailById(event.prediction.placeId ?? "");
          Location? location = placesDetail.result?.geometry?.location;
          if (location != null) {
            LatLng latLng = LatLng(location.lat!, location.lng!);

            showRequestSheet = true;
            add(OnDirectionEvent(latLng: latLng));
          } else {
            // error message
            log("locaation laat long is null");
          }
        } catch (error) {
          log("error occur in catch $error", name: "OnLocationSelectedEvent");
        }
      },
    );
    on<NearByDriverAddedEvent>(
      (event, emit) async {
        final updatedMarkers = <Marker>{};
        final currentDriverIds =
            event.nearByDrivers.map((driver) => driver.driverUid ?? "").toSet();

        var icon = await BitmapDescriptor.asset(
          const ImageConfiguration(devicePixelRatio: 1.2, size: Size(50, 50)),
          "assets/pngwing.com.png",
        );

        for (final driver in event.nearByDrivers) {
          Marker driverMarker = Marker(
              markerId: MarkerId(driver.driverUid ?? ""),
              position: LatLng(driver.latLong?.geoPoint?.latitude ?? 0.0,
                  driver.latLong?.geoPoint?.longitude ?? 0.0),
              icon: icon);
          updatedMarkers.add(driverMarker);
        }
        nearByDriverMarker = updatedMarkers;
        nearByDriverMarker.removeWhere(
            (marker) => !currentDriverIds.contains(marker.markerId.value));

        emit(OnNearByDriverAdded());
      },
    );

    on<OnRequestForRiding>(
      (event, emit) {
        try {
          emit(OnRidingRequestLoadingState());
        } catch (error) {}
      },
    );
  }
}
