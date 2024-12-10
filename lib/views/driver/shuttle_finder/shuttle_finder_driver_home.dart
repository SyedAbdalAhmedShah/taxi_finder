import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/views/driver/taxi_finder_service/driver_map_view.dart';

class ShuttleFinderDriverHome extends StatelessWidget {
  const ShuttleFinderDriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          welcomeBack,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          DriverMapView(),
        ],
      ),
    );
  }
}
