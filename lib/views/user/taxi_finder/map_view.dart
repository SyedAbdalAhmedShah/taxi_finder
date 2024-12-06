import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/taxi_finder_bloc/taxi_finder_user_bloc.dart';
import 'package:taxi_finder/utils/utils.dart';

class UserMapView extends StatefulWidget {
  const UserMapView({super.key});

  @override
  State<UserMapView> createState() => UserMapViewState();
}

class UserMapViewState extends State<UserMapView> {
  late TaxiFinderUserBloc userMapBloc;

  @override
  void initState() {
    userMapBloc = context.read<TaxiFinderUserBloc>();
    userMapBloc.add(FetchCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaxiFinderUserBloc, TaxiFinderUserState>(
      listener: (context, state) {
        if (state is UserMapFailureState) {
          Utils.showErrortoast(errorMessage: state.errorMessage);
        } else if (state is UpdateMapState) {
          userMapBloc.nearByDriversStreamSubscription =
              userMapBloc.nearByDriversStream.listen(
            (event) {
              userMapBloc.add(
                NearByDriverAddedEvent(nearByDrivers: event),
              );
            },
          );
        }
      },
      child: BlocBuilder<TaxiFinderUserBloc, TaxiFinderUserState>(
        builder: (context, state) {
          log("State $state");
          return ModalProgressHUD(
            blur: 2,
            progressIndicator: UserMapLoadingWidget(states: state),
            inAsyncCall: state is UserMapLoadingState ||
                state is OnRidingRequestLoadingState,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: userMapBloc.cameraPosition,
              onMapCreated: (GoogleMapController controller) async {
                userMapBloc.gController = controller;
              },
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
            ),
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

class UserMapLoadingWidget extends StatelessWidget {
  final TaxiFinderUserState states;
  const UserMapLoadingWidget({required this.states, super.key});

  @override
  Widget build(BuildContext context) {
    if (states is OnRidingRequestLoadingState) {
      return Center(
        child: Column(
          children: [
            const Text('Finding nearby and available driver for you '),
            Gap(1.h),
            const CircularProgressIndicator.adaptive()
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
