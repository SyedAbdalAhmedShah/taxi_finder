import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late BitmapDescriptor icon;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Location location = Location();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(bearing: 192.8334901395799, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 19.151926040649414);
  Set<Polyline> polylines = {
    const Polyline(
      polylineId: PolylineId('route1'),
      points: [
        LatLng(37.7749, -122.4194),
        LatLng(37.8051, -122.4300),
        LatLng(37.8070, -122.4093),
      ],
      color: Colors.blue,
      width: 4,
    ),
  };
  Set<Marker> markers = {};

  Future<void> _getUserLocation() async {
    final userLocation = await location.getLocation();
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId('userLocation'),
        position: LatLng(userLocation.latitude!, userLocation.longitude!),
        icon: icon,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
    });
  }

// Cargar imagen del Marker
  getIcons() async {
    var icon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 1.2, size: Size(50, 50)),
      "assets/pngwing.com.png",
    );
    setState(() {
      this.icon = icon;
    });
  }

  @override
  void initState() {
    getIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
     
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        polylines: polylines,
        onCameraMoveStarted: () => log("message"),
        markers: markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onTap: (LatLng latLng) {
          // Hide info window when tapping on the map
          setState(() {
            for (var marker in markers) {
              markers.remove(marker.copyWith(infoWindowParam: InfoWindow.noText));
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getUserLocation,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
