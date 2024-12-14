import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/shuttle_ride_request.dart';
import 'package:taxi_finder/models/user_request_model.dart';
import 'package:taxi_finder/utils/utils.dart';

mixin DriverMapRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final loggedRole = locator.get<CurrentUserDependency>();

  Future updateDriverLocation(Position position) async {
    DriverInfo driverInfo = loggedRole.driverInfo;
    log("Driver uid ${driverInfo.driverUid}");
    log("Driver latlong ${driverInfo.latLong?.geoPoint?.latitude}  == ${driverInfo.latLong?.geoPoint?.longitude}");
    final ref = _firebaseFirestore.collection(FirebaseStrings.driverColl);
    await GeoCollectionReference(ref).updatePoint(
      id: driverInfo.driverUid ?? "",
      field: FirebaseStrings.latLong,
      geopoint: GeoPoint(position.latitude, position.longitude),
    );
  }

  Stream<List<ShuttleRideRequest>> requestByUserShuttleServiceToDriver() {
    final ref = _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid)
        .collection(FirebaseStrings.shuttleRideReq)
        .where(FirebaseStrings.status, isEqualTo: FirebaseStrings.pending);

    final snapShot = ref.snapshots();

    Stream<List<ShuttleRideRequest>> streamShuttle =
        snapShot.asyncMap((e) async {
      List<ShuttleRideRequest> processedRequests = [];

      for (var da in e.docs) {
        ShuttleRideRequest shuttleRideRequest =
            ShuttleRideRequest.fromJson(da.data());

        // Apply your future function here
        ShuttleRideRequest newShuttleRideRequest =
            await _processRideRequest(shuttleRideRequest);

        processedRequests.add(newShuttleRideRequest);
      }

      return processedRequests;
    });

    streamShuttle.listen((data) {
      log("================length ${data.length}=======");
    });

    return streamShuttle;
  }

  // Future function to process the shuttle ride request
  // Future<ShuttleRideRequest> processShuttleRideRequest(
  //     ShuttleRideRequest originalRequest) async {
  //   try {
  //     // Perform your additional processing here
  //     // For example, calculate distance, update status, etc.

  //     // Example: Add some processing logic
  //     final processedRequest = originalRequest.copyWith(
  //         // Modify properties as needed
  //         // For instance:
  //         // status: 'processed',
  //         // additionalDetails: await calculateSomeDetails()
  //         );

  //     return processedRequest;
  //   } catch (e) {
  //     print('Error processing shuttle ride request: $e');
  //     // Return the original request if processing fails
  //     return originalRequest;
  //   }
  // }
  // Stream<List<ShuttleRideRequest>> requestByUserShuttleServiceToDriver() {
  //   final ref = _firebaseFirestore
  //       .collection(FirebaseStrings.driverColl)
  //       .doc(loggedRole.driverInfo.driverUid)
  //       .collection(FirebaseStrings.shuttleRideReq)
  //       .where(FirebaseStrings.status, isEqualTo: FirebaseStrings.pending);
  //   final snapShot = ref.snapshots();
  //   Stream<List<ShuttleRideRequest>> streamShuttle =
  //       snapShot.map((e) => e.docs.map((da) {
  //             ShuttleRideRequest shuttleRideRequest =
  //                 ShuttleRideRequest.fromJson(da.data());

  //             return shuttleRideRequest;
  //           }).toList());
  //   streamShuttle.listen((data) {
  //     log("================length ${data.length}=======");
  //   });
  //   return streamShuttle;
  // }

  Future<ShuttleRideRequest> _processRideRequest(
      ShuttleRideRequest request) async {
    Position currentLocation = await Geolocator.getCurrentPosition();

    LatLng latLng = LatLng(
        request.userPickUpLocation?.geoPoint?.latitude ?? 0.0,
        request.userPickUpLocation?.geoPoint?.longitude ?? 0.0);
    final data = await Utils.getPolyLinesAndMarker(
        currentLocationPosition: currentLocation, destLocationPosition: latLng);
    log("=========== ${data.$1}");
    ShuttleRideRequest shuttleRideRequest =
        request.copyWith(totalDistanceToUser: data.$1);
    return shuttleRideRequest;
  }

  // await Utils.getPolyLinesAndMarker(
  //               currentLocationPosition: currentLocationPosition,
  //               destLocationPosition: event.latLng);
  Stream<List<UserRequestModel>> requestbyUserToDriver() {
    final ref = _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid)
        .collection(FirebaseStrings.rideRequestColl)
        .where(FirebaseStrings.status, isEqualTo: FirebaseStrings.pending);
    final snapshot = ref.snapshots();
    Stream<List<UserRequestModel>> requestStream =
        snapshot.asyncMap((event) async {
      List<UserRequestModel> requestModel = [];
      final doc = await _firebaseFirestore
          .collection(FirebaseStrings.driverColl)
          .doc(loggedRole.driverInfo.driverUid)
          .get();
      DriverInfo driverInfo = DriverInfo.fromJson(doc.data() ?? {});

      if (driverInfo.activeRide == null) {
        requestModel = event.docs
            .map(
              (e) => UserRequestModel.fromJson(e.data()),
            )
            .toList();
      } else {
        requestModel = [];
      }

      return requestModel;
    });

    return requestStream;
  }

  Future updateRideRequestedDoc(
      {required String docId, required String status}) async {
    await _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid)
        .collection(FirebaseStrings.rideRequestColl)
        .doc(docId)
        .update({FirebaseStrings.status: status});
  }

  Future updateDriverShuttleRideRequest(
      {required String docId, required String status}) async {
    await _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid)
        .collection(FirebaseStrings.shuttleRideReq)
        .doc(docId)
        .update({FirebaseStrings.status: status});
  }

  acceptRequestAndUpdateDriverColl(String requestId) async {
    final driverDoc = _firebaseFirestore.collection(FirebaseStrings.driverColl);

    driverDoc
        .doc(loggedRole.driverInfo.driverUid)
        .set({FirebaseStrings.activeRide: requestId}, SetOptions(merge: true));
    _firebaseFirestore
        .collection(FirebaseStrings.rideRequestColl)
        .doc(requestId)
        .set({
      FirebaseStrings.status: FirebaseStrings.accepted,
      FirebaseStrings.driverUid: loggedRole.driverInfo.driverUid
    }, SetOptions(merge: true));
  }

  markCompletedOfDriverRideRequestCollection(
      {required String driverId, required String requestId}) async {
    final driverDoc =
        _firebaseFirestore.collection(FirebaseStrings.driverColl).doc(driverId);
    final rideRequestCol =
        driverDoc.collection(FirebaseStrings.rideRequestColl).doc(requestId);
    await Future.wait([
      driverDoc.update({FirebaseStrings.activeRide: null}),
      rideRequestCol.update({FirebaseStrings.status: FirebaseStrings.completed})
    ]);
  }

  markAsCompletedRideRequestCollection({required String requestId}) async {
    final rideRequestCol = _firebaseFirestore
        .collection(FirebaseStrings.rideRequestColl)
        .doc(requestId);
    await rideRequestCol.update({
      FirebaseStrings.status: FirebaseStrings.completed,
      FirebaseStrings.completeAt: Timestamp.now()
    });
  }
}
