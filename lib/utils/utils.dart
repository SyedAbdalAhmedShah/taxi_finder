import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/utils/api_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Utils {
  static PolylinePoints polylinePoints = PolylinePoints();
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String firebaseSignInErrors(String code) {
    final errorMessage = switch (code) {
      ('invalid-email') => 'Invalid email format.',
      ('user-not-found') => 'No user found with this email.',
      ('wrong-password') => 'Incorrect password.',
      ('user-disabled') => 'User account is disabled.',
      ('network-request-failed') => "Please check your internet connection",
      ('invalid-credential') => " Username or password is incorrect",
      (_) => 'An undefined error occurred: ',
    };
    log('firebase errror $code');
    return errorMessage;
  }

  static showErrortoast({required String errorMessage}) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0.sp);
  }

  static Future<(String totalDistance, Polyline polyLine, Marker maarker)>
      getPolyLinesAndMarker(
          {required Position currentLocationPosition,
          required LatLng destLocationPosition,
          String? iconPath}) async {
    var icon = iconPath != null
        ? await BitmapDescriptor.asset(
            const ImageConfiguration(devicePixelRatio: 1.2, size: Size(50, 50)),
            iconPath,
          )
        : BitmapDescriptor.defaultMarker;
    List<LatLng> routeCoords = [];
    PointLatLng currentLocPoint = PointLatLng(
        currentLocationPosition.latitude, currentLocationPosition.longitude);
    PointLatLng destinationLocPoint = PointLatLng(
        destLocationPosition.latitude, destLocationPosition.longitude);
    PolylineResult points = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: ApiHelper().placesApiKey,
        request: PolylineRequest(
            origin: currentLocPoint,
            destination: destinationLocPoint,
            mode: TravelMode.driving));

    log('error= = = = = = ${points.errorMessage}');
    if (points.points.isNotEmpty) {
      log('points is not empty ');
      routeCoords =
          points.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    } else {
      log('Error: ${points.errorMessage}');
    }
    log("distance ${(points.distanceTexts)}");
    String totalDistance = points.distanceTexts?.first ?? "";
    Polyline polyline = Polyline(
      polylineId: const PolylineId("Direction Route 1"),
      points: routeCoords,
      color: secondaryColor,
    );
    Marker destinationMarker = Marker(
        icon: icon,
        markerId: const MarkerId("destination"),
        infoWindow: InfoWindow(title: "${points.endAddress}"),
        position: LatLng(routeCoords.last.latitude, routeCoords.last.longitude),
        visible: true);
    return (totalDistance, polyline, destinationMarker);
  }

  static updateDriver({required String driverUid}) async {
    final docsnap =
        firebaseFirestore.collection(FirebaseStrings.driverColl).doc(driverUid);
    final driverData = await docsnap.get();

    if (driverData.exists) {
      await docsnap.update({FirebaseStrings.activeRide: null});
      DriverInfo driverInfo = DriverInfo.fromJson(driverData.data() ?? {});
      return driverInfo;
    } else {
      return null;
    }
  }

  static Future<DriverInfo?> driver({required String driverUid}) async {
    final docsnap =
        firebaseFirestore.collection(FirebaseStrings.driverColl).doc(driverUid);
    final driverData = await docsnap.get();

    if (driverData.exists) {
      log('driver exisit');
      DriverInfo driverInfo = DriverInfo.fromJson(driverData.data() ?? {});
      return driverInfo;
    } else {
      return null;
    }
  }

  static Future<UserModel?> getUserData({required String uid}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore
            .collection(FirebaseStrings.usersColl)
            .doc(uid)
            .get();
    if (documentSnapshot.exists) {
      UserModel userModel = UserModel.fromFirestore(documentSnapshot);

      return userModel;
    } else {
      return null;
    }
  }

  static Future<String> getPlatformDeviceID() async {
    String deviceId = "";
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }
    log('deviceId $deviceId');
    return deviceId;
  }
}
