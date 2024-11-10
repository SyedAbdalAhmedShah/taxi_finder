import 'package:flutter/material.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/views/driver/components/driver_drawer.dart';
import 'package:taxi_finder/views/driver/driver_map_view.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          welcomeBack,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Stack(
        children: [
          
          DriverMapView(),
        ],
      ),
    );
  }
}
