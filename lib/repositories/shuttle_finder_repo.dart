import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/driver_info.dart';

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
        return query.where(FirebaseStrings.driverType,
            isEqualTo: shuttleService);
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
}
