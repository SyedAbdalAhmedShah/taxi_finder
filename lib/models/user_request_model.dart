
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart'; // For GeoPoint

class UserRequestModel {
  String address;
  String status;
  String uid;
  LatLong? userLatLong;

  UserRequestModel({
    required this.address,
    required this.status,
    required this.uid,
    required this.userLatLong,
  });

  // Convert JSON to UserLocation object
  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      address: json[FirebaseStrings.address] as String,
      status: json[FirebaseStrings.status] as String,
      uid: json[FirebaseStrings.uid] as String,
      userLatLong: json[FirebaseStrings.latLong] != null
          ? LatLong.fromJson(json[FirebaseStrings.latLong])
          : null,
    );
  }

  // Convert UserLocation object to JSON
  Map<String, dynamic> toJson() {
    return {
      FirebaseStrings.address: address,
      FirebaseStrings.status: status,
      FirebaseStrings.uid: uid,
      FirebaseStrings.userLatlong: userLatLong,
    };
  }
}
