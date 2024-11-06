import 'package:flutter/material.dart';

import 'package:taxi_finder/components/logout_button.dart';
import 'package:taxi_finder/views/driver/driver_map_view.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [LogoutButton()],
      ),
      body: const Stack(
        children: [
          DriverMapView(),
        ],
      ),
    );
  }
}
