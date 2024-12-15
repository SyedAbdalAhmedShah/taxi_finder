import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/shuttle_ride_request.dart';
import 'package:taxi_finder/utils/utils.dart';

mixin ShuttleFinderRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final loggedRole = locator.get<CurrentUserDependency>();

  Stream<List<DriverInfo>> getNearByShuttleFinderDrivers(LatLng positionns) {
    GeoPoint location = GeoPoint(positionns.latitude, positionns.longitude);
    final GeoFirePoint center = GeoFirePoint(location);
    const double radiusInKm = 50;
    final ref = firebaseFirestore.collection(FirebaseStrings.driverColl);
    Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
        GeoCollectionReference<Map<String, dynamic>>(ref).subscribeWithin(
      center: center,
      radiusInKm: radiusInKm,
      field: FirebaseStrings.latLong,
      queryBuilder: (query) {
        return query
            .where(FirebaseStrings.driverType, isEqualTo: shuttleService)
            .where(FirebaseStrings.isSeatsFull, isEqualTo: false);
      },
      strictMode: true,
      geopointFrom: (obj) {
        return obj[FirebaseStrings.latLong][FirebaseStrings.geoPoint];
      },
    );

    Stream<List<DriverInfo>> driverInfo = stream.asBroadcastStream().map(
          (event) => event
              .map(
                (e) => DriverInfo.fromJson(e.data() ?? {}),
              )
              .toList(),
        );

    // final driverSteamSubscriptions = driverInfo.listen((driverInfo) {});
    return driverInfo;
  }

  Future saveRequestForUser(
      {required String numOfSeats,
      required String to,
      required String fare,
      required bool pickUpFromMyLocation}) async {
    Position userCurrentLocation = await Geolocator.getCurrentPosition();
    LatLng latLng =
        LatLng(userCurrentLocation.latitude, userCurrentLocation.longitude);
    final GeoFirePoint userPickUpLocation = await Utils.getGeoFirePoint(latLng);
    final doc =
        firebaseFirestore.collection(FirebaseStrings.shuttleRideReq).doc();
    String requestId = doc.id;
    Map<String, dynamic> data = {
      FirebaseStrings.userId: loggedRole.userModel.uid,
      FirebaseStrings.userPickUpLocation: userPickUpLocation.data,
      FirebaseStrings.numOfSeats: numOfSeats,
      FirebaseStrings.to: to,
      FirebaseStrings.fare: fare,
      FirebaseStrings.pickUpFromMyLocation: pickUpFromMyLocation,
      FirebaseStrings.status: FirebaseStrings.pending,
      FirebaseStrings.docId: doc.id,
      FirebaseStrings.createdAt: Timestamp.now(),
    };
    await doc.set(data);
    return requestId;
  }

  Future sendBookingRequestToNearByDrivers(
      {required String driverUid,
      required String numOfSeats,
      required String to,
      required String fare,
      required bool pickUpFromMyLocation,
      required String reqquestId}) async {
    Position userCurrentLocation = await Geolocator.getCurrentPosition();
    LatLng latLng =
        LatLng(userCurrentLocation.latitude, userCurrentLocation.longitude);
    final GeoFirePoint userPickUpLocation = await Utils.getGeoFirePoint(latLng);
    final doc = firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(driverUid)
        .collection(FirebaseStrings.shuttleRideReq)
        .doc(reqquestId);
    Map<String, dynamic> data = {
      FirebaseStrings.userId: loggedRole.userModel.uid,
      FirebaseStrings.userPickUpLocation: userPickUpLocation.data,
      FirebaseStrings.numOfSeats: numOfSeats,
      FirebaseStrings.to: to,
      FirebaseStrings.fare: fare,
      FirebaseStrings.pickUpFromMyLocation: pickUpFromMyLocation,
      FirebaseStrings.requestId: reqquestId,
      FirebaseStrings.status: FirebaseStrings.pending,
      FirebaseStrings.createdAt: Timestamp.now(),
    };

    await doc.set(data);
  }

  Future<int> fetchRequestDocsForSeatsLeft(
      {required DriverInfo driverIfon}) async {
    List<ShuttleRideRequest> driverAllActiveRequest = [];
    int allConsumedSeats = 0;
    final driverShuttleReqColl = firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(driverIfon.driverUid)
        .collection(FirebaseStrings.shuttleRideReq);
    List<String> driverActiveRequests = driverIfon.shuttleRide ?? [];
    if (driverActiveRequests.isNotEmpty) {
      for (final request in driverActiveRequests) {
        DocumentSnapshot<Map<String, dynamic>> requestData =
            await driverShuttleReqColl.doc(request).get();
        ShuttleRideRequest shuttleRideRequest =
            ShuttleRideRequest.fromJson(requestData.data()!);
        driverAllActiveRequest.add(shuttleRideRequest);
      }
    }

    for (final shuttleReq in driverAllActiveRequest) {
      int? seatsBook = int.tryParse(shuttleReq.numberOfSeats ?? "0");
      if (seatsBook != null) {
        allConsumedSeats += seatsBook;
      }
    }

    return allConsumedSeats;
  }
}
