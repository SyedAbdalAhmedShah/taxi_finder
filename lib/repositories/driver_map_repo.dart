import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/driver_info.dart';

mixin DriverMapRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final loggedRole = locator.get<CurrentUserDependency>();
  StreamSubscription<Position> getPositionListner() {
    return Geolocator.getPositionStream().listen(
      (event) {},
    );
  }

  Future updateDriverLocation() async {
    DriverInfo driverInfo = loggedRole.driverInfo;
    log("Driver uid ${driverInfo.driverUid}");
    //  _firebaseFirestore.collection(FirebaseStrings.driverColl).doc()
  }
}
