import 'dart:convert';
import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/models/auto_complete_model.dart';
import 'package:taxi_finder/models/place_detail_model.dart';
import 'package:taxi_finder/utils/api_helper.dart';

class UserMapRepo {
  PolylinePoints polylinePoints = PolylinePoints();
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

  Future<(String totalDistance, Polyline polyLine, Marker maarker)>
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

  double getTotalFare(String totalDistance) {
    int baseFare = 8;
    int farePerKM = 5;
    log("totalDistance ${totalDistance.toUpperCase()}");
    double distanceIntoDouble =
        double.parse(totalDistance.toUpperCase().replaceAll("KM", ""));
    log("distanceIntoDouble $distanceIntoDouble");
    double fareWithTotalDistance = farePerKM * distanceIntoDouble;
    double totalFare = fareWithTotalDistance + baseFare;

    return totalFare;
  }
}
// distaance  2.7 km