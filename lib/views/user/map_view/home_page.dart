import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxi_finder/views/user/map_view/map_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  checkLocationPermission() async {
    PermissionStatus location = await Permission.location.request();
    if (!location.isGranted) {
      checkLocationPermission();
    }
  }

  @override
  void initState() {
    checkLocationPermission();
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
