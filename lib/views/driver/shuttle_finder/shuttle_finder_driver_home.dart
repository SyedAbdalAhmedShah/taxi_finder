import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_shuttle_service_bloc/driver_shuttle_service_bloc.dart';
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
          _DriverShuttleMapView(),
        ],
      ),
    );
  }
}

class _DriverShuttleMapView extends StatefulWidget {
  const _DriverShuttleMapView();

  @override
  State<_DriverShuttleMapView> createState() => _DriverShuttleMapViewState();
}

class _DriverShuttleMapViewState extends State<_DriverShuttleMapView> {
  late DriverShuttleServiceBloc _driverShuttleServiceBloc;

  @override
  void initState() {
    _driverShuttleServiceBloc = context.read<DriverShuttleServiceBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _driverShuttleServiceBloc.cameraPosition,
      onMapCreated: (GoogleMapController controller) async {
        _driverShuttleServiceBloc.mapController = controller;
      },
      polylines: _driverShuttleServiceBloc.polylineSet,
      markers: _driverShuttleServiceBloc.markers,
      buildingsEnabled: true,
      fortyFiveDegreeImageryEnabled: true,
      myLocationButtonEnabled: true,
      trafficEnabled: true,
      myLocationEnabled: true,
      onTap: (LatLng latLng) {},
    );
  }
}
