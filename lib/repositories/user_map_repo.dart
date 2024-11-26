import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/models/auto_complete_model.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/place_detail_model.dart';
import 'package:taxi_finder/models/ride_request_model.dart';
import 'package:taxi_finder/utils/api_helper.dart';

class UserMapRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final loggedRole = locator.get<CurrentUserDependency>();
  Future getDirection(
      {required LatLng source, required LatLng destination}) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${source.latitude},${source.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=${ApiHelper().placesApiKey}';

    Response response = await get(Uri.parse(url));
    final data = json.decode(response.body);
    log("Url respponse data ${data}");
    final route = data['routes'][0];
    final leg = route['legs'][0];
    final distance = leg['distance']['text'];
    log("distaance  $distance");
  }

  Future<List<Prediction>> getPlacesSuggestion(
      {required String query, required String countryISO}) async {
    final autoCompleteUrl =
        "${ApiHelper().googleMapBaseUrl}${ApiHelper().autoCompleteApi}$query&country=$countryISO&key=${ApiHelper().placesApiKey}";
    Response response = await get(Uri.parse(autoCompleteUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      AutoCompleteModel autoComplete = AutoCompleteModel.fromJson(data);
      if (autoComplete.status != null && autoComplete.status == "OK") {
        return autoComplete.predictions!;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<PlacesDetail> getPlaceDetailById(String placeId) async {
    final String placeDetailUrl =
        "${ApiHelper().googleMapBaseUrl}${ApiHelper().placeDetailApi}$placeId&key=${ApiHelper().placesApiKey}";
    Response response = await get(Uri.parse(placeDetailUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      PlacesDetail placesDetail = PlacesDetail.fromJson(data);
      if (placesDetail.status != null && placesDetail.status == "OK") {
        return placesDetail;
      } else {
        throw "No Place detail found";
      }
    } else {
      throw "Something went wrong, No place detail found";
    }
  }

  double getTotalFare(String totalDistance) {
    int baseFare = 8;
    int farePerKM = 4;
    log("totalDistance ${totalDistance.toUpperCase()}");
    double distanceIntoDouble =
        double.parse(totalDistance.toUpperCase().replaceAll("KM", ""));
    log("distanceIntoDouble $distanceIntoDouble");
    double fareWithTotalDistance = farePerKM * distanceIntoDouble;
    double totalFare = fareWithTotalDistance + baseFare;

    return totalFare;
  }

  Stream<List<DriverInfo>> getNearByDrivers(LatLng positionns) {
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
        return query.where(FirebaseStrings.activeRide, isNull: true);
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

  Map<String, double> calculateBoundingBox(
      double lat, double lon, double distanceInKm) {
    const earthRadius = 6371;
    double latDelta = distanceInKm / earthRadius * (180 / math.pi);
    double lonDelta = distanceInKm /
        earthRadius *
        (180 / math.pi) /
        math.cos(lat * math.pi / 180);

    return {
      "minLat": lat - latDelta,
      "maxLat": lat + latDelta,
      "minLon": lon - lonDelta,
      "maxLon": lon + lonDelta,
    };
  }

  Future<(String address, String isoCode)> getFullStringAddress(
      GeoPoint currentLocationPosition) async {
    List<Placemark> placemarks = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(currentLocationPosition.latitude,
            currentLocationPosition.longitude);
    Placemark placemark = placemarks.first;
    String address =
        "${placemark.street ?? ""}${placemark.subLocality ?? ""} ${placemark.locality ?? ""} ${placemark.administrativeArea ?? ""} ${placemark.country ?? ""}";
    String countryISOCode = placemark.isoCountryCode ?? "PK";
    return (address, countryISOCode);
  }

  Future requestToNearByDriver(GeoPoint driverGeopoint, GeoPoint pickUpLocation,
      String driverId, String destination, GeoPoint dropOffLocation) async {
    final GeoFirePoint userPickUpLocation = GeoFirePoint(pickUpLocation);
    final GeoFirePoint userDropOffLocation = GeoFirePoint(dropOffLocation);

    double distance =
        userPickUpLocation.distanceBetweenInKm(geopoint: driverGeopoint);

    final stringAddress = await getFullStringAddress(pickUpLocation);
    final ref = firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(driverId)
        .collection(FirebaseStrings.ridesColl)
        .doc();
    log('total distaance $distance: ');
    ref.set({
      FirebaseStrings.userPickUpLocation: userPickUpLocation.data,
      FirebaseStrings.userDropOffLocation: userDropOffLocation.data,
      FirebaseStrings.address: stringAddress.$1,
      FirebaseStrings.destination: destination,
      FirebaseStrings.docId: ref.id,
      FirebaseStrings.userId: loggedRole.userModel.uid,
      FirebaseStrings.status: FirebaseStrings.pending,
    });
  }

  Future notifyNearByDriver(
      {required String destination,
      required String driverId,
      required String requestId,
      required GeoPoint pickUpLocation,
      required GeoPoint dropOffLocation}) async {
    final GeoFirePoint userPickUpLocation = GeoFirePoint(pickUpLocation);
    final GeoFirePoint userDropOffLocation = GeoFirePoint(dropOffLocation);
    final stringAddress = await getFullStringAddress(pickUpLocation);
    await firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(driverId)
        .collection(FirebaseStrings.rideRequestColl)
        .doc(requestId)
        .set({
      FirebaseStrings.requestId: requestId,
      FirebaseStrings.userPickUpLocation: userPickUpLocation.data,
      FirebaseStrings.userDropOffLocation: userDropOffLocation.data,
      FirebaseStrings.address: stringAddress.$1,
      FirebaseStrings.destination: destination,
      FirebaseStrings.status: FirebaseStrings.pending,
      FirebaseStrings.createdAt: FieldValue.serverTimestamp(),
    });
  }

  Future<String> addRideRequest(GeoPoint pickUpLocation, String destination,
      GeoPoint dropOffLocation) async {
    final GeoFirePoint userPickUpLocation = GeoFirePoint(pickUpLocation);
    final GeoFirePoint userDropOffLocation = GeoFirePoint(dropOffLocation);
    DocumentReference<Map<String, dynamic>> doc =
        firebaseFirestore.collection(FirebaseStrings.rideRequestColl).doc();

    await doc.set({
      FirebaseStrings.userPickUpLocation: userPickUpLocation.data,
      FirebaseStrings.userDropOffLocation: userDropOffLocation.data,
      FirebaseStrings.docId: doc.id,
      FirebaseStrings.timStamp: FieldValue.serverTimestamp(),
      FirebaseStrings.status: FirebaseStrings.pending,
    });
    return doc.id;
  }

  Stream<List<RideRequest>> getRequestStream({required String docId}) {
    return firebaseFirestore
        .collection(FirebaseStrings.rideRequestColl)
        .where(FirebaseStrings.docId, isEqualTo: docId)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RideRequest.fromJson(e.data())).toList());
  }

  updateUserWhenAcceptRideByDriver(
      {required String uid, required String requestId}) async {
    await firebaseFirestore
        .collection(FirebaseStrings.usersColl)
        .doc(uid)
        .set({FirebaseStrings.activeRide: requestId}, SetOptions(merge: true));
  }
}
// distaance  2.7 km