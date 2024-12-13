import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/models/user_request_model.dart';
import 'package:taxi_finder/repositories/driver_map_repo.dart';
import 'package:taxi_finder/utils/api_helper.dart';
import 'package:taxi_finder/utils/notification_service.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'driver_taxi_finder_state.dart';

part 'driver_taxi_finder_event.dart';

class DriverTaxiFinderBLoc
    extends Bloc<DriverTaxiFinderEvent, DriverTaxiFinderState>
    with DriverMapRepo {
  late GoogleMapController mapController;
  late List<UserRequestModel> userRequest;
  StreamSubscription<Position>? positionStream;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late Position driverCurrentPosition;
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  late UserRequestModel currentRideRequest;
  DriverTaxiFinderBLoc() : super(DriverInitial()) {
    on<DriverCurrentLocationEvent>((event, emit) async {
      emit(DriverMapLoadingState());
      try {
        bool isPermisssionGranted = await Utils.isPermissionGranted();
        if (isPermisssionGranted) {
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
          add(DriverCurrentLocationEvent());
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
        await acceptRequestAndUpdateDriverColl(
            event.userRequestModel.requestId ?? "");
        await updateRideRequestedDoc(
            docId: event.userRequestModel.requestId ?? "",
            status: FirebaseStrings.accepted);
        currentRideRequest = event.userRequestModel;
        LatLng userPickupPoint = LatLng(
            event.userRequestModel.userPickUpLocation?.geoPoint?.latitude ??
                0.0,
            event.userRequestModel.userPickUpLocation?.geoPoint?.longitude ??
                0.0);
        Polyline polyline;
        Marker destinationMarker;
        String totalDistance;

        (totalDistance, polyline, destinationMarker) =
            await Utils.getPolyLinesAndMarker(
                currentLocationPosition: driverCurrentPosition,
                destLocationPosition: userPickupPoint);
        polylineSet.add(polyline);
        markers.add(destinationMarker);
        emit(RideAcceptedState());
      },
    );

    on<ReachedOnUserPickupLocation>((event, emit) async {
      try {
        String userId = currentRideRequest.userUid ?? "";
        log("cuser id $userId");
        UserModel? userModel = await Utils.getUserData(uid: userId);
        if (userModel != null) {
          String accessToken = await ApiHelper().generateFCMAccessToken();
          await NotificationService.sendNotification(
              accessToken: accessToken,
              driverName: loggedRole.driverInfo.fullName ?? "",
              requestId: currentRideRequest.requestId ?? "",
              fcmToken: userModel.token ?? "");
          LatLng userPickupPoint = LatLng(
              currentRideRequest.userDropOffLocation?.geoPoint?.latitude ?? 0.0,
              currentRideRequest.userDropOffLocation?.geoPoint?.longitude ??
                  0.0);
          Polyline polyline;
          Marker destinationMarker;
          String totalDistance;

          (totalDistance, polyline, destinationMarker) =
              await Utils.getPolyLinesAndMarker(
                  currentLocationPosition: driverCurrentPosition,
                  destLocationPosition: userPickupPoint);
          polylineSet = {};
          markers = {};
          polylineSet.add(polyline);
          markers.add(destinationMarker);
          emit(ReachedOnUserPickupLocationState());
        } else {
          emit(DriverMapFailureState());
        }
      } catch (e) {
        log('error happened in OnUserPickupLocationReached $e',
            name: "Driver bloc");
        emit(DriverMapFailureState());
      }
    });

    on<OnRideCompletedEvent>((event, emit) async {
      try {
        await markCompletedOfDriverRideRequestCollection(
            driverId: loggedRole.driverInfo.driverUid ?? "",
            requestId: currentRideRequest.requestId ?? "");
        await markAsCompletedRideRequestCollection(
            requestId: currentRideRequest.requestId ?? "");
        polylineSet = {};
        markers = {};
        emit(CompletedRideState());
      } catch (e) {
        log('error happened in OnRideCompletedEvent $e', name: "Driver bloc");
        emit(DriverMapFailureState());
      }
    });
  }
}
