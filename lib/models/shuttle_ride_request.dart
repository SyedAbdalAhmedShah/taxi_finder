import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';

class ShuttleRideRequest {
  final String? fare;
  final String? numberOfSeats;
  final bool? pickUpFromMyLocation;
  final String? requestId;
  final String? docId;
  final String? status;
  final String? to;
  final String? userId;
  final String? driverUid;
  Timestamp? createdAt;
  LatLong? userPickUpLocation;
  String? totalDistanceToUser;

  ShuttleRideRequest({
    this.fare,
    this.numberOfSeats,
    this.pickUpFromMyLocation,
    this.requestId,
    this.status,
    this.to,
    this.userId,
    this.createdAt,
    this.userPickUpLocation,
    this.totalDistanceToUser,
    this.docId,
    this.driverUid,
  });

  // Factory constructor to create a TripRequest from a JSON map
  factory ShuttleRideRequest.fromJson(Map<String, dynamic> json) {
    return ShuttleRideRequest(
      fare: json['fare'] as String?,
      numberOfSeats: json['numberOfSeats'] as String?,
      pickUpFromMyLocation: json['pickUpFromMyLocation'] as bool?,
      requestId: json['requestId'] as String?,
      status: json['status'] as String?,
      docId: json['docId'] as String?,
      to: json['to'] as String?,
      userId: json['userId'] as String?,
      driverUid: json['driverUid'] as String?,
      createdAt: json[FirebaseStrings.createdAt] as Timestamp?,
      userPickUpLocation: json[FirebaseStrings.userPickUpLocation] != null
          ? LatLong.fromJson(json[FirebaseStrings.userPickUpLocation])
          : null,
    );
  }

  // Method to convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'fare': fare,
      'numberOfSeats': numberOfSeats,
      'pickUpFromMyLocation': pickUpFromMyLocation,
      'requestId': requestId,
      'status': status,
      'to': to,
      'userId': userId,
      'docId': docId,
      'driverUid': driverUid,
      FirebaseStrings.createdAt: createdAt,
      FirebaseStrings.userPickUpLocation: userPickUpLocation
    };
  }

  // Optional: Add a copyWith method for easy modification
  ShuttleRideRequest copyWith(
      {String? fare,
      String? numberOfSeats,
      bool? pickUpFromMyLocation,
      String? requestId,
      String? status,
      String? to,
      String? userId,
      Timestamp? createdAt,
      String? totalDistanceToUser,
      LatLong? userPickUpLocation}) {
    return ShuttleRideRequest(
      fare: fare ?? this.fare,
      numberOfSeats: numberOfSeats ?? this.numberOfSeats,
      pickUpFromMyLocation: pickUpFromMyLocation ?? this.pickUpFromMyLocation,
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
      to: to ?? this.to,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      userPickUpLocation: userPickUpLocation ?? this.userPickUpLocation,
      totalDistanceToUser: totalDistanceToUser ?? this.totalDistanceToUser,
    );
  }

  @override
  String toString() {
    return 'TripRequest(fare: $fare, numberOfSeats: $numberOfSeats, pickUpFromMyLocation: $pickUpFromMyLocation, requestId: $requestId, status: $status, to: $to, userId: $userId)';
  }
}
