import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart'; // For GeoPoint

class UserRequestModel {
  String? address;
  String? status;
  String? requestId;
  String? destination;
  LatLong? userPickUpLocation;
  LatLong? userDropOffLocation;
  Timestamp? createdAt;
  String? userUid;

  UserRequestModel({
    this.destination,
    this.address,
    this.status,
    this.requestId,
    this.userPickUpLocation,
    this.userDropOffLocation,
    this.createdAt,
    this.userUid,
  });

  // Convert JSON to UserLocation object
  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      address: json[FirebaseStrings.address],
      destination: json[FirebaseStrings.destination],
      status: json[FirebaseStrings.status] as String,
      createdAt: json[FirebaseStrings.createdAt] as Timestamp,
      requestId: json[FirebaseStrings.requestId] as String,
      userUid: json[FirebaseStrings.userId],
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
      FirebaseStrings.requestId: requestId,
      FirebaseStrings.userPickUpLocation: userPickUpLocation,
      FirebaseStrings.userDropOffLocation: userDropOffLocation,
      FirebaseStrings.userId: userUid,
    };
  }
}
