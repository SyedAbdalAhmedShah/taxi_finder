import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:taxi_finder/models/auto_complete_model.dart';
import 'package:taxi_finder/utils/api_helper.dart';

class UserMapRepo {
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
    final placesUrl =
        "${ApiHelper().googleMapBaseUrl}${ApiHelper().places}$query&country=$countryISO&key=${ApiHelper().placesApiKey}";
    Response response = await get(Uri.parse(placesUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      AutoCompleteModel autoComplete = AutoCompleteModel.fromJson(data);
      log("Auto completee status ${autoComplete.status}");
      log("predictions ${autoComplete.predictions.toString()}");
      if (autoComplete.status != null && autoComplete.status == "OK") {
        return autoComplete.predictions!;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
// distaance  2.7 km