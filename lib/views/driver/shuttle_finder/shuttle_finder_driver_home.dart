import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_shuttle_service_bloc/driver_shuttle_service_bloc.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/views/driver/components/user_shuttle_request.dart';

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
          UserShuttleRequestSection(),
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
    _driverShuttleServiceBloc.add(DriverCurrentLocationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverShuttleServiceBloc, DriverShuttleServiceState>(
      listener: (context, state) {
        if (state is ShuttleDriverCurrentLocationState) {
          _driverShuttleServiceBloc.positionStream?.onData((position) {
            _driverShuttleServiceBloc.updateDriverLocation(position);
          });
        }
      },
      child: BlocBuilder<DriverShuttleServiceBloc, DriverShuttleServiceState>(
        builder: (context, state) {
          if (state is DriverShuttleServiceLoadingState) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
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
        },
      ),
    );
  }
}

class UserShuttleRequestSection extends StatelessWidget {
  const UserShuttleRequestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (ctx, index) => UserShuttleRequestCard());
  }
}
