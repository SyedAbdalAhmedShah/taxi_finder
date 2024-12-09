import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';

mixin ShuttleCityToCityRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<List<CityToCityModel>> getAvailableCities() async {
    QuerySnapshot<Map<String, dynamic>> docs = await firebaseFirestore
        .collection(FirebaseStrings.shuttleCityToCityColl)
        .get();
    final allDocs = docs.docs;
    List<CityToCityModel> allAvailableCities =
        allDocs.map((data) => CityToCityModel.fromJson(data.data())).toList();
    return allAvailableCities;
  }
}
