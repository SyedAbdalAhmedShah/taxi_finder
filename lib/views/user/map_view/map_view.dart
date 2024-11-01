import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late UserMapBloc userMapBloc;

  late BitmapDescriptor icon;

  Set<Polyline> polylines = {
    const Polyline(
      polylineId: PolylineId('route1'),
      points: [LatLng(37.7749, -122.4194), LatLng(34.0522, -118.2437)],
      color: Colors.blue,
      width: 4,
    ),
  };
  Set<Marker> markers = {};

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
    userMapBloc = context.read<UserMapBloc>();
    userMapBloc.add(FetchCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserMapBloc, UserMapState>(
      builder: (context, state) {
        log("State $state");
        return state is UserMapLoadingState
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: userMapBloc.cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: userMapBloc.polylineSet,
                onCameraMoveStarted: () => log("message"),
                markers: markers,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onTap: (LatLng latLng) {
                  // Hide info window when tapping on the map
                  setState(() {
                    for (var marker in markers) {
                      markers.remove(
                          marker.copyWith(infoWindowParam: InfoWindow.noText));
                    }
                  });
                },
              );
      },
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
