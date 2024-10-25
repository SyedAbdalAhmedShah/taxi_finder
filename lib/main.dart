import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/views/auth/sign_in_view.dart';
import 'package:taxi_finder/views/bridge/bridge.dart';
import 'package:taxi_finder/views/user/map_view/map_view.dart';

void main() {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // Force Hybrid Composition mode.
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Taxi Finder',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BridgeScreen(

        ),
      );
    });
  }
}
