import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/auto_complete_model.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/place_detail_model.dart';
import 'package:taxi_finder/models/ride_request_model.dart';
import 'package:taxi_finder/repositories/user_map_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'taxi_finder_user_event.dart';
part 'taxi_finder_user_state.dart';

class TaxiFinderUserBloc
    extends Bloc<TaxiFinderUserEvent, TaxiFinderUserState> {
  UserMapRepo userMapRepo = UserMapRepo();
  late GoogleMapController gController;
  late Stream<List<DriverInfo>> nearByDriversStream;
  late StreamSubscription<List<DriverInfo>> nearByDriversStreamSubscription;
  StreamSubscription? rideRequestStream;
  Timer? rideRequestTimer;
  Set<Marker> nearByDriverMarker = {};
  List<DriverInfo> nearByDrivers = [];
  Geolocator location = Geolocator();
  TextEditingController myLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? countryISO;

  TextEditingController totalSeatBookController = TextEditingController();
  List<Prediction> searchLocations = [];
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late Position currentLocationPosition;

  late GeoPoint destinationLocation;

  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};

  TaxiFinderUserBloc() : super(UserMapInitial()) {
    on<FetchCurrentLocation>((event, emit) async {
      emit(UserMapLoadingState());
      try {
        bool isPermissionGranted = await Utils.isPermissionGranted();

        if (isPermissionGranted) {
          currentLocationPosition = await Geolocator.getCurrentPosition();
          LatLng currentLatLong = LatLng(currentLocationPosition.latitude,
              currentLocationPosition.longitude);
          nearByDriversStream = userMapRepo.getNearByDrivers(currentLatLong);
          GeoPoint currentGeoPoint =
              GeoPoint(currentLatLong.latitude, currentLatLong.longitude);
          final placeMarkers =
              await Utils.getFullStringAddress(currentGeoPoint);

          countryISO = placeMarkers.$2;
          myLocationController.text = placeMarkers.$1;

          cameraPosition = CameraPosition(
            target: currentLatLong,
            zoom: 15.4746,
          );
          gController
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
              await Utils.getPolyLinesAndMarker(
                  currentLocationPosition: currentLocationPosition,
                  destLocationPosition: event.latLng);
          destinationLocation =
              GeoPoint(event.latLng.latitude, event.latLng.longitude);
          final totalLocationDistance = totalDistance;

          final totalfare =
              userMapRepo.getTotalFare(totalLocationDistance).toString();
          polylineSet.add(polyline);
          cameraPosition = CameraPosition(
              target: LatLng(currentLocationPosition.latitude,
                  currentLocationPosition.longitude),
              zoom: 10.0);
          markers.add(destinationMarker);
          emit(OnDirectionRequestState(
              totalFare: totalfare,
              totalLocationDistance: totalDistance,
              totalSeatBookController: totalSeatBookController.text));
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
          vanImage,
        );
        nearByDrivers = event.nearByDrivers;
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

    on<OnRequestForRiding>((event, emit) async {
      try {
        emit(OnRidingRequestLoadingState());

        GeoPoint userGeoPoint = GeoPoint(currentLocationPosition.latitude,
            currentLocationPosition.longitude);

        if (nearByDriverMarker.isNotEmpty) {
          String requestId = await userMapRepo.addRideRequest(
              userGeoPoint, destinationController.text, destinationLocation);
          rideRequestTimer = Timer(const Duration(minutes: 2), () {
            emit(UserMapFailureState(errorMessage: noRiderAvail));
          });
          for (final drivers in nearByDrivers) {
            await userMapRepo.notifyNearByDriver(
                destination: destinationController.text,
                driverId: drivers.driverUid ?? "",
                requestId: requestId,
                pickUpLocation: userGeoPoint,
                dropOffLocation: destinationLocation);
          }

          final requestStrem = userMapRepo.getRequestStream(docId: requestId);
          requestStrem.listen((request) {
            RideRequest rideRequest = request.first;
            if (rideRequest.status == FirebaseStrings.accepted) {
              log('Ride accepted');
              nearByDriversStreamSubscription.pause();
              add(RideAcceptedByDriverEvent(rideRequest: rideRequest));
            } else if (rideRequest.status == FirebaseStrings.completed) {
              polylineSet.clear();
              markers.clear();
              add(FetchCurrentLocation());
            } else {
              log('Ride status ============================================== ${rideRequest.status}');
            }
          });
        } else {
          emit(UserMapFailureState(errorMessage: noRiderAvail));
        }
      } catch (error) {
        log("Error occure $error", name: "OnRequestForRiding");
        emit(UserMapFailureState(errorMessage: technicalIssue));
      }
    });
    on<RideAcceptedByDriverEvent>((event, emit) async {
      emit(OnRidingRequestLoadingState());
      CurrentUserDependency currentUser = locator.get<CurrentUserDependency>();
      try {
        log("RideAcceptedByDriverEvent triggered");
        Polyline polyline;
        Marker driverMarker;
        String totalDistance;
        cancleRidesThings();
        await userMapRepo.updateUserWhenAcceptRideByDriver(
            uid: currentUser.userModel.uid ?? "",
            requestId: event.rideRequest.docId ?? "");

        DriverInfo? driverInfo =
            await Utils.driver(driverUid: event.rideRequest.driverUid ?? "");
        LatLng driverLocationLatLong = LatLng(
          driverInfo?.latLong?.geoPoint?.latitude ?? 0.0,
          driverInfo?.latLong?.geoPoint?.longitude ?? 0.0,
        );
        (totalDistance, polyline, driverMarker) =
            await Utils.getPolyLinesAndMarker(
                currentLocationPosition: currentLocationPosition,
                destLocationPosition: driverLocationLatLong,
                iconPath: vanImage);

        markers.clear();
        nearByDriverMarker.clear();
        polylineSet.clear();
        polylineSet.add(polyline);
        markers.add(driverMarker);
        emit(OnRideRequestAcceptState(driverInfo: driverInfo!));
      } catch (error) {
        log("error happened in RideAcceptedByDriverEvent $error",
            name: "User bloc");
      }
    });
  }

  cancleRidesThings() {
    if (rideRequestTimer != null) {
      rideRequestTimer?.cancel();
    }
    if (rideRequestStream != null) {
      rideRequestStream?.cancel();
    }
  }
}
