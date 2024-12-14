import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_taxi_finder_%20bloc%20/driver_taxi_finder_bloc.dart';

class DriverMapView extends StatefulWidget {
  const DriverMapView({super.key});

  @override
  State<DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  late DriverTaxiFinderBLoc driverBloc;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    driverBloc = context.read<DriverTaxiFinderBLoc>();
    driverBloc.add(DriverCurrentLocationEvent());

    driverBloc.positionStream?.onData(
      (position) async {
        await driverBloc.updateDriverLocation(position);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    driverBloc.positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverTaxiFinderBLoc, DriverTaxiFinderState>(
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
