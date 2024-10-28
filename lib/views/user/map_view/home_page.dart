import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:taxi_finder/views/user/map_view/map_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  checkLocationPermission() async {
    location.enableBackgroundMode(enable: true);
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      log("faalse ");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
      // _permissionGranted = await location.hasPermission();
      // if (_permissionGranted == PermissionStatus.denied) {
      //   _permissionGranted = await location.requestPermission();
      //   if (_permissionGranted != PermissionStatus.granted) {
      //     return;
      //   }
      // }
    }
  }

  @override
  void initState() {
    // checkLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [MapSample()],
      ),
    );
  }
}
