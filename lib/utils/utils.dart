import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/utils/api_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:taxi_finder/utils/extensions.dart';

class Utils {
  static PolylinePoints polylinePoints = PolylinePoints();
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String firebaseSignInErrors(String code) {
    final errorMessage = switch (code) {
      ('invalid-email') => 'Invalid email format.',
      ('user-not-found') => 'No user found with this email.',
      ('wrong-password') => 'Incorrect password.',
      ('user-disabled') => 'User account is disabled.',
      ('network-request-failed') => "Please check your internet connection",
      ('invalid-credential') => " Username or password is incorrect",
      (_) => 'An undefined error occurred: ',
    };
    log('firebase errror $code');
    return errorMessage;
  }

  static showErrortoast({required String errorMessage}) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0.sp);
  }

  static Future<(String totalDistance, Polyline polyLine, Marker maarker)>
      getPolyLinesAndMarker(
          {required Position currentLocationPosition,
          required LatLng destLocationPosition,
          String? iconPath}) async {
    var icon = iconPath != null
        ? await BitmapDescriptor.asset(
            const ImageConfiguration(devicePixelRatio: 1.2, size: Size(50, 50)),
            iconPath,
          )
        : BitmapDescriptor.defaultMarker;
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
      log('points is not empty ');
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
        icon: icon,
        markerId: const MarkerId("destination"),
        infoWindow: InfoWindow(title: "${points.endAddress}"),
        position: LatLng(routeCoords.last.latitude, routeCoords.last.longitude),
        visible: true);
    return (totalDistance, polyline, destinationMarker);
  }

  static updateDriver({required String driverUid}) async {
    final docsnap =
        firebaseFirestore.collection(FirebaseStrings.driverColl).doc(driverUid);
    final driverData = await docsnap.get();

    if (driverData.exists) {
      await docsnap.update({FirebaseStrings.activeRide: ""});
      DriverInfo driverInfo = DriverInfo.fromJson(driverData.data() ?? {});
      return driverInfo;
    } else {
      return null;
    }
  }

  static Future<DriverInfo?> driver({required String driverUid}) async {
    final docsnap =
        firebaseFirestore.collection(FirebaseStrings.driverColl).doc(driverUid);
    final driverData = await docsnap.get();

    if (driverData.exists) {
      log('driver exisit');
      DriverInfo driverInfo = DriverInfo.fromJson(driverData.data() ?? {});
      return driverInfo;
    } else {
      return null;
    }
  }

  static Future<UserModel?> getUserData({required String uid}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore
            .collection(FirebaseStrings.usersColl)
            .doc(uid)
            .get();
    if (documentSnapshot.exists) {
      UserModel userModel = UserModel.fromFirestore(documentSnapshot);

      return userModel;
    } else {
      return null;
    }
  }

  static Future<String> getPlatformDeviceID() async {
    String deviceId = "";
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }
    log('deviceId $deviceId');
    return deviceId;
  }

  static Future<bool> isPermissionGranted() async {
    LocationPermission isPermissionEnable = await Geolocator.checkPermission();
    if (isPermissionEnable == LocationPermission.always ||
        isPermissionEnable == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  static Future<(String address, String isoCode)> getFullStringAddress(
      GeoPoint currentLocationPosition) async {
    List<Placemark> placemarks = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(currentLocationPosition.latitude,
            currentLocationPosition.longitude);
    Placemark placemark = placemarks.first;
    String address =
        "${placemark.street ?? ""}${placemark.subLocality ?? ""} ${placemark.locality ?? ""} ${placemark.administrativeArea ?? ""} ${placemark.country ?? ""}";
    String countryISOCode = placemark.isoCountryCode ?? "PK";
    return (address, countryISOCode);
  }

  static showShuttleSelectedDialog(
      {required BuildContext context, required CityToCityModel cityModel}) {
    TextEditingController numberOfSeats = TextEditingController();
    final shuttleFinderBloc = context.read<ShuttleFinderBloc>();
    final formKey = GlobalKey<FormState>();
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) => BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
              builder: (context, state) {
                return Material(
                  color: Colors.transparent,
                  child: ModalProgressHUD(
                    inAsyncCall: state is OnRideBookingLoadingState,
                    blur: 2,
                    progressIndicator:
                        const CircularProgressIndicator.adaptive(),
                    child: AlertDialog.adaptive(
                      actions: [
                        TextButton.icon(
                            icon: Icon(Icons.adaptive.arrow_back),
                            onPressed: () => context.pop(),
                            label: Text("cancel"))
                      ],
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                'From: ',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              Text(
                                '${cityModel.from} ',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Gap(1.h),
                          Row(
                            children: [
                              Text(
                                'To: ',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              Text(
                                '${cityModel.to} ',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Gap(1.h),
                          Row(
                            children: [
                              Text(
                                'Cost: ',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              Text(
                                '${cityModel.fare} ',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Gap(1.h),
                          Form(
                            key: formKey,
                            child: AppTextField(
                                keyboardType: TextInputType.number,
                                fillColor: Colors.grey.shade700,
                                hintText: seatWantToRes,
                                validator: (p0) => p0 == null || p0.isEmpty
                                    ? "Please enter seats you want to book"
                                    : null,
                                controller: numberOfSeats),
                          ),
                          Gap(1.h),
                          Row(
                            children: [
                              BlocBuilder<ShuttleFinderBloc,
                                  ShuttleFinderState>(
                                builder: (context, state) {
                                  return Checkbox(
                                      value: shuttleFinderBloc
                                          .pickMeUpFromMyLocation,
                                      onChanged: (v) => shuttleFinderBloc
                                          .add(PickMeUpFromMyLocationByUser()));
                                },
                              ),
                              const Text(pickMeUp),
                            ],
                          ),
                          BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
                            builder: (context, state) {
                              return NoteWhenPickFromLocation(
                                isPickMeUp:
                                    shuttleFinderBloc.pickMeUpFromMyLocation,
                              );
                            },
                          ),
                          Gap(1.h),
                          PrimaryButton(
                              text: bookRide,
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  shuttleFinderBloc.add(OnBookShuttleRide(
                                      selectedCity: cityModel,
                                      numOfSeats: numberOfSeats.text));
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
  }

  static Future<GeoFirePoint> getGeoFirePoint(LatLng latLong) async {
    GeoPoint userGeoPoint = GeoPoint(latLong.latitude, latLong.longitude);
    final GeoFirePoint userPickUpLocation = GeoFirePoint(userGeoPoint);
    return userPickUpLocation;
  }

  static StreamSubscription<Position> getPositionListner() {
    return Geolocator.getPositionStream().listen(
      (event) {},
    );
  }
}

class NoteWhenPickFromLocation extends StatelessWidget {
  final bool isPickMeUp;
  const NoteWhenPickFromLocation({required this.isPickMeUp, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.all(1.w),
      height: isPickMeUp ? 16.h : 0,
      decoration: BoxDecoration(
          color: Colors.yellow.shade100,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(1.w)),
      duration: Durations.medium1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            additionalCharges,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Gap(0.5.h),
          Text(
            "• 1-4.9 KM = R15",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
          Gap(0.5.h),
          Text(
            "• 5-9.9 KM = R30",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
          Gap(0.5.h),
          Text(
            "• 10-15 KM = R50",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
