import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_request_model.dart';

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

  requestByUserShuttleServiceToDriver() {
    final ref = _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid)
        .collection(FirebaseStrings.rideRequestColl)
        .where(FirebaseStrings.status, isEqualTo: FirebaseStrings.pending);
  }

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
