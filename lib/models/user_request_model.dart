import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart'; // For GeoPoint

class UserRequestModel {
  String? address;
  String? status;
  String? uid;
  String? destination;
  String? userId;
  LatLong? userPickUpLocation;
  LatLong? userDropOffLocation;

  UserRequestModel({
    this.destination,
    this.userId,
    this.address,
    this.status,
    this.uid,
    this.userPickUpLocation,
    this.userDropOffLocation,
  });

  // Convert JSON to UserLocation object
  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      address: json[FirebaseStrings.address],
      destination: json[FirebaseStrings.destination],
      status: json[FirebaseStrings.status] as String,
      userId: json[FirebaseStrings.userId] as String,
      uid: json[FirebaseStrings.uid] as String,
      userPickUpLocation: json[FirebaseStrings.userPickUpLocation] != null
          ? LatLong.fromJson(json[FirebaseStrings.userPickUpLocation])
          : null,
      userDropOffLocation: json[FirebaseStrings.userDropOffLocation] != null
          ? LatLong.fromJson(json[FirebaseStrings.userDropOffLocation])
          : null,
    );
  }

  // Convert UserLocation object to JSON
  Map<String, dynamic> toJson() {
    return {
      FirebaseStrings.address: address,
      FirebaseStrings.destination: destination,
      FirebaseStrings.status: status,
      FirebaseStrings.uid: uid,
      FirebaseStrings.userId: userId,
      FirebaseStrings.userPickUpLocation: userPickUpLocation,
      FirebaseStrings.userDropOffLocation: userDropOffLocation,
    };
  }
}
