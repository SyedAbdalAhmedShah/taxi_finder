import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Custom Place class for clustering

class ShuttleService extends StatefulWidget {
  const ShuttleService({super.key});

  @override
  _ShuttleServiceState createState() => _ShuttleServiceState();
}

class _ShuttleServiceState extends State<ShuttleService> {
  late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          const CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }
}
