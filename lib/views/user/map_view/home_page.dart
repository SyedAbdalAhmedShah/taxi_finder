import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/views/user/components/location_search_section.dart';
import 'package:taxi_finder/views/user/map_view/map_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late UserMapBloc userMapBloc;
  // late bool _serviceEnabled;
  // late PermissionStatus _permissionGranted;
  // late LocationData _locationData;
  checkLocationPermission() {
    // location.enableBackgroundMode(enable: true);
    // _serviceEnabled = await location.serviceEnabled();
    // log("_serviceEnabled $_serviceEnabled ");
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    // _permissionGranted = await location.hasPermission();
    // log("permission status $_permissionGranted");
    // if (_permissionGranted == PermissionStatus.denied) {
    //   await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }
  }

  @override
  void initState() {
    // checkLocationPermission();
    userMapBloc = context.read<UserMapBloc>();
    userMapBloc.add(FetchCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(
      children: [MapSample(), LocationSearchSection()],
    ));
  }
}
