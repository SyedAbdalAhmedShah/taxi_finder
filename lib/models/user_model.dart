import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';

class UserModel {
  final String? email;
  final GeoPoint? currentLocation;
  final String? uid;
  final String? fullName;
  final String? deviceId;
  final String? token;

  UserModel({
    required this.email,
    required this.currentLocation,
    required this.uid,
    required this.fullName,
    required this.deviceId,
    required this.token,
  });

  // Factory constructor to create an instance from Firebase data
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
        email: data['email'] ?? '',
        currentLocation: data['currentLocation'] as GeoPoint,
        uid: data['uid'] ?? '',
        fullName: data['fullName'] ?? '',
        token: data[FirebaseStrings.token] ?? '',
        deviceId: data[FirebaseStrings.deviceId] ?? "");
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'currentLocation': currentLocation,
      'uid': uid,
      'fullName': fullName,
      FirebaseStrings.token: token,
      FirebaseStrings.deviceId: deviceId,
    };
  }
}
