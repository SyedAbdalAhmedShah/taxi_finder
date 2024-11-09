import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';

class DriverInfo {
  String? driverUid;
  String? fullName;
  String? address;
  String? contactNumber;
  String? idCardNumber;
  String? email;
  String? licenseNumber;
  DateTime? licenseIssueDate;
  DateTime? licenseExpiryDate;
  String? carRegNumber;
  String? companyName;
  String? carModel;
  int? numberOfSeats;
  String? carColor;
  String? status;
  String? carDocUrl;
  String? licenseImageUrl;
  String? profileUrl;
  String? carInsceptionReport;
  LatLong? latLong;

  DriverInfo(
      {this.driverUid,
      this.address,
      this.carColor,
      this.carModel,
      this.carRegNumber,
      this.companyName,
      this.contactNumber,
      this.email,
      this.fullName,
      this.idCardNumber,
      this.licenseExpiryDate,
      this.numberOfSeats,
      this.licenseIssueDate,
      this.status = "Pending",
      this.carDocUrl,
      this.carInsceptionReport,
      this.licenseImageUrl,
      this.profileUrl,
      this.latLong,
      this.licenseNumber});

  // Convert from JSON
  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    Timestamp? issueTimeStamp = json[FirebaseStrings.licenseIssueDate];
    Timestamp? expireTimeStamp = json[FirebaseStrings.licenseExpiryDate];
    DateTime issueDateTime = DateTime.now();
    DateTime expireDateTime = DateTime.now();

    if (issueTimeStamp != null) {
      issueDateTime = issueTimeStamp.toDate();
    }
    if (expireTimeStamp != null) {
      expireDateTime = expireTimeStamp.toDate();
    }
    return DriverInfo(
        driverUid: json[FirebaseStrings.driverUid],
        fullName: json[FirebaseStrings.fullName],
        address: json[FirebaseStrings.address],
        contactNumber: json[FirebaseStrings.contactNumber],
        idCardNumber: json[FirebaseStrings.idCardNumber],
        email: json[FirebaseStrings.email],
        licenseNumber: json[FirebaseStrings.licenseNumber],
        licenseIssueDate: issueDateTime,
        licenseExpiryDate: expireDateTime,
        carRegNumber: json[FirebaseStrings.carRegNumber],
        numberOfSeats: json[FirebaseStrings.numOfSeats],
        companyName: json[FirebaseStrings.companyName],
        carModel: json[FirebaseStrings.carModel],
        carColor: json[FirebaseStrings.carColor],
        carDocUrl: json[FirebaseStrings.carDocUrl],
        carInsceptionReport: json[FirebaseStrings.carInsceptionReport],
        licenseImageUrl: json[FirebaseStrings.licenseImageUrl],
        profileUrl: json[FirebaseStrings.profileUrl],
        status: json[FirebaseStrings.status],
        latLong: LatLong.fromJson(json[FirebaseStrings.latLong]));
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      FirebaseStrings.driverUid: driverUid,
      FirebaseStrings.fullName: fullName,
      FirebaseStrings.address: address,
      FirebaseStrings.contactNumber: contactNumber,
      FirebaseStrings.idCardNumber: idCardNumber,
      FirebaseStrings.email: email,
      FirebaseStrings.licenseNumber: licenseNumber,
      FirebaseStrings.licenseIssueDate: licenseIssueDate,
      FirebaseStrings.licenseExpiryDate: licenseExpiryDate,
      FirebaseStrings.carRegNumber: carRegNumber,
      FirebaseStrings.companyName: companyName,
      FirebaseStrings.carModel: carModel,
      FirebaseStrings.carColor: carColor,
      FirebaseStrings.carDocUrl: carDocUrl,
      FirebaseStrings.carInsceptionReport: carInsceptionReport,
      FirebaseStrings.licenseImageUrl: licenseImageUrl,
      FirebaseStrings.profileUrl: profileUrl,
      FirebaseStrings.status: status,
      FirebaseStrings.numOfSeats: numberOfSeats
    };
  }
}

class LatLong {
  final String? geoHash;
  final GeoPoint? geoPoint;

  LatLong({this.geoHash, this.geoPoint});
  Map<String, dynamic> toJson() {
    return {
      FirebaseStrings.geohash: geoHash,
      FirebaseStrings.geoPoint: geoPoint != null
          ? {'latitude': geoPoint!.latitude, 'longitude': geoPoint!.longitude}
          : null,
    };
  }

  // Create a LatLong instance from a JSON object
  factory LatLong.fromJson(Map<String, dynamic> json) {
    return LatLong(
        geoHash: json[FirebaseStrings.geohash],
        // ignore: prefer_if_null_operators
        geoPoint: json[FirebaseStrings.geoPoint] != null
            ? json[FirebaseStrings.geoPoint]
            : null);
  }
}
