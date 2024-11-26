import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';

class RideRequest {
  final String? docId;
  final String? status;
  final String? driverUid;
  final Timestamp? timestamp; // Firestore timestamp
  final LatLong? userDropOffLocation;
  final LatLong? userPickUpLocation;

  // Constructor
  RideRequest({
    this.docId,
    this.status,
    this.timestamp,
    this.userDropOffLocation,
    this.driverUid,
    this.userPickUpLocation,
  });

  // Factory method to create an instance from a Map (fromJson)
  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      docId: json[FirebaseStrings.docId],
      status: json[FirebaseStrings.status],
      timestamp: json[FirebaseStrings.timStamp] as Timestamp,
      driverUid: json[FirebaseStrings.driverUid] ,
      userDropOffLocation:
          LatLong.fromJson(json[FirebaseStrings.userDropOffLocation]),
      userPickUpLocation:
          LatLong.fromJson(json[FirebaseStrings.userPickUpLocation]),
    );
  }

  // Method to convert the object back to a Map (toJson)
  Map<String, dynamic> toJson() {
    return {
      FirebaseStrings.docId: docId,
      FirebaseStrings.status: status,
      FirebaseStrings.timStamp: timestamp,
      FirebaseStrings.userDropOffLocation: userDropOffLocation!.toJson(),
      FirebaseStrings.userPickUpLocation: userPickUpLocation!.toJson(),
    };
  }
}
