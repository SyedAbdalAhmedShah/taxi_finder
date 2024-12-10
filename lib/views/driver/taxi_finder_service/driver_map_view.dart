import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_bloc.dart';

class DriverMapView extends StatefulWidget {
  const DriverMapView({super.key});

  @override
  State<DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  late DriverBloc driverBloc;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    driverBloc = context.read<DriverBloc>();
    driverBloc.add(DriverCurrentLocationEvent());

    driverBloc.positionStream?.onData(
      (position) {
        driverBloc.updateDriverLocation(position);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(
      builder: (context, state) {
        log("driver map state$state  camera position ======  ${driverBloc.cameraPosition.target.latitude} ${driverBloc.cameraPosition.target.longitude}");
        return state is DriverMapLoadingState
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: driverBloc.cameraPosition,

                onMapCreated: (GoogleMapController controller) async {
                  driverBloc.mapController = controller;
                },
                polylines: driverBloc.polylineSet,
                markers: driverBloc.markers,
                buildingsEnabled: true,
                fortyFiveDegreeImageryEnabled: true,
                // polylines: userMapBloc.polylineSet,
                // markers: userMapBloc.markers,
                myLocationButtonEnabled: true,
                trafficEnabled: true,
                myLocationEnabled: true,
                onTap: (LatLng latLng) {},
              );
      },
    );
  }
}
