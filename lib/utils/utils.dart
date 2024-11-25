import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/utils/api_helper.dart';

class Utils {
  static PolylinePoints polylinePoints = PolylinePoints();

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
          required LatLng destLocationPosition}) async {
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
        markerId: const MarkerId("destination"),
        infoWindow: InfoWindow(title: "${points.endAddress}"),
        position: LatLng(routeCoords.last.latitude, routeCoords.last.longitude),
        visible: true);
    return (totalDistance, polyline, destinationMarker);
  }
}
