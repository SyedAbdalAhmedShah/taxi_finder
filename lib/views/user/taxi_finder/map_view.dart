import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/utils/utils.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
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

  @override
  void initState() {
    userMapBloc = context.read<UserMapBloc>();
    userMapBloc.add(FetchCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserMapBloc, UserMapState>(
      listener: (context, state) {
        if (state is UserMapFailureState) {
          Utils.showErrortoast(errorMessage: state.errorMessage);
        } else if (state is UpdateMapState) {
          userMapBloc.nearByDriversStream.listen(
            (event) {
              userMapBloc.add(
                NearByDriverAddedEvent(nearByDrivers: event),
              );
            },
          );
        }
      },
      child: BlocBuilder<UserMapBloc, UserMapState>(
        builder: (context, state) {
          log("State $state");
          return state is UserMapLoadingState
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: userMapBloc.cameraPosition,
                  onMapCreated: (GoogleMapController controller) async {},
                  buildingsEnabled: true,
                  fortyFiveDegreeImageryEnabled: true,
                  polylines: userMapBloc.polylineSet,
                  onCameraMoveStarted: () => log("message"),
                  markers: {
                    ...userMapBloc.nearByDriverMarker,
                    ...userMapBloc.markers
                  },
                  myLocationButtonEnabled: true,
                  trafficEnabled: true,
                  myLocationEnabled: true,
                  onTap: (LatLng latLng) {
                    log('latitude ${latLng.latitude}');
                    log('longitude ${latLng.longitude}');
                  },
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
