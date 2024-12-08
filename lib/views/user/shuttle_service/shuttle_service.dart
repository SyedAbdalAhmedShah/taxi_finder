import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/views/user/shuttle_service/available_cities.dart';

// Custom Place class for clustering

class ShuttleService extends StatefulWidget {
  const ShuttleService({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShuttleServiceState createState() => _ShuttleServiceState();
}

class _ShuttleServiceState extends State<ShuttleService> {
  late ShuttleFinderBloc _shuttleFinderBloc;

  @override
  void initState() {
    _shuttleFinderBloc = context.read<ShuttleFinderBloc>();
    _shuttleFinderBloc.add(GetUserCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is ShuttleFinderLoadingState,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _shuttleFinderBloc.cameraPosition,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _shuttleFinderBloc.googleMapController = controller;
                  },
                ),
                _ShuttleAvailableCities(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ShuttleAvailableCities extends StatelessWidget {
  const _ShuttleAvailableCities({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(10, (i) => AvailableCities()),
        ),
      ),
    );
  }
}
