import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/utils/api_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/views/user/components/shuttle_available_drivers.dart';
import 'package:taxi_finder/views/user/components/shuttle_booking_dialog_content.dart';
import 'package:taxi_finder/views/user/components/shuttle_driver_intro_content.dart';

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
    showDialog(
      context: context,
      builder: (ctx) => BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is OnRideBookingLoadingState,
            blur: 2,
            progressIndicator: const CircularProgressIndicator.adaptive(),
            child: Dialog(
              insetPadding: EdgeInsets.all(2.w),
              child: ShowCaseWidget(
                onFinish: () async {
                  log("booking intro on finished callled");
                  SharedPrefrencesDependency sharedPrefrencesDependency =
                      locator.get();
                  SharedPreferences preferences =
                      sharedPrefrencesDependency.preferences;
                  await preferences.setBool(bookingShuttleRideIntro, true);

                  Navigator.of(context).pop();
                  Utils.showNearByDriversDialogIntro(context);
                },
                builder: (ctx) => ShuttleBookingDiloagContent(
                  cityModel: cityModel,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static showNearByDriversDialogIntro(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
        builder: (context, state) {
          return SizedBox(
            height: 60.h,
            child: Material(
              color: Colors.transparent,
              child: ModalProgressHUD(
                inAsyncCall: state is OnRideBookingLoadingState,
                blur: 2,
                progressIndicator: const CircularProgressIndicator.adaptive(),
                child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  child: ShowCaseWidget(
                    onFinish: () async {
                      SharedPrefrencesDependency sharedPrefrencesDependency =
                          locator.get();
                      SharedPreferences preferences =
                          sharedPrefrencesDependency.preferences;
                      await preferences.setBool(
                          shuttleRequestDriverIntro, true);
                      context.pop();
                    },
                    builder: (ctx) => ShuttleDriverIntroContent(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static showshowNearByDriversDialog(
    BuildContext context,
    String noSeatsWantToBook,
    List<DriverInfo> availableDrivers,
    String requestId,
    CityToCityModel city,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => BlocListener<ShuttleFinderBloc, ShuttleFinderState>(
        listener: (context, state) {
          if (state is RideCancledState) {
            context.pop();
          }
        },
        child: BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
          builder: (context, state) {
            return SizedBox(
              height: 60.h,
              child: ModalProgressHUD(
                inAsyncCall: state is OnRideBookingLoadingState,
                blur: 2,
                progressIndicator: const CircularProgressIndicator.adaptive(),
                child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (ctx) => CupertinoActionSheet(
                                    title: Text("Ride Actions"),
                                    message:
                                        Text("Do you want to cancel ride?"),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: Text("No"),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          context.read<ShuttleFinderBloc>().add(
                                              OnRideCancelEvent(
                                                  requestId: requestId));
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  ));
                        },
                        icon: Icon(Icons.close),
                      ),
                      Expanded(
                        child: ShuttleAvailableDrivers(
                          availableDrivers: availableDrivers,
                          selectedCity: city,
                          requestId: requestId,
                          noSeatsWantToBook: noSeatsWantToBook,
                        ),
                      ),
                      PrimaryButton(
                          text: "Send To All",
                          onPressed: () {
                            context.read<ShuttleFinderBloc>().add(
                                OnSendShuttleRideRequestToAllDrivers(
                                    noOfSeats: noSeatsWantToBook,
                                    requestId: requestId,
                                    selectedCity: city));
                          })
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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

  static showDriverDepratureTimePicker(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
        barrierDismissible: false,
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: "Please Select Departure Time",
        confirmText: "Set Departure Time",
        cancelText: "Until its full");
    if (timeOfDay != null) {
      final selectedTime = timeOfDay.format(context);
      await updateDriverDepratureTime(depTime: selectedTime);
    } else {
      await updateDriverDepratureTime(depTime: untilItsFull);
    }
  }

  static updateDriverDepratureTime({required String depTime}) async {
    CurrentUserDependency loggedUser = locator.get();
    final driverDoc = firebaseFirestore
        .collection(FirebaseStrings.driverColl)
        .doc(loggedUser.driverInfo.driverUid);
    await driverDoc.update({FirebaseStrings.deperatureTime: depTime});
  }
}
