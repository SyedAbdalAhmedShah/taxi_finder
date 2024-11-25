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
  StreamSubscription<Position> getPositionListner() {
    return Geolocator.getPositionStream().listen(
      (event) {},
    );
  }

  Future updateDriverLocation(Position position) async {
    DriverInfo driverInfo = loggedRole.driverInfo;
    log("Driver uid ${driverInfo.driverUid}");
    log("Driver latlong ${driverInfo.latLong}");
    final ref = _firebaseFirestore.collection(FirebaseStrings.driverColl);
    await GeoCollectionReference(ref).updatePoint(
      id: driverInfo.driverUid ?? "",
      field: FirebaseStrings.latLong,
      geopoint: GeoPoint(position.latitude, position.longitude),
    );
  }

  Stream<List<UserRequestModel>> requestbyUserToDriver() {
    final ref = _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid)
        .collection(FirebaseStrings.rideRequestColl)
        .where(FirebaseStrings.status, isEqualTo: FirebaseStrings.inProcess);
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
        .collection(FirebaseStrings.ridesColl)
        .doc(docId)
        .update({FirebaseStrings.status: status});
  }

  acceptRequest(String docId) async {
    final ref = _firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedRole.driverInfo.driverUid);
    ref.set({FirebaseStrings.activeRide: docId}, SetOptions(merge: true));
  }
}
