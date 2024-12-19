import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taxi_finder/blocs/bloc/shuttle_city_to_city_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/utils/utils.dart';
import 'package:taxi_finder/views/user/shuttle_service/available_cities.dart';
import 'package:skeletonizer/skeletonizer.dart';
// Custom Place class for clustering

class ShuttleService extends StatefulWidget {
  const ShuttleService({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShuttleServiceState createState() => _ShuttleServiceState();
}

class _ShuttleServiceState extends State<ShuttleService> {
  late ShuttleFinderBloc _shuttleFinderBloc;
  late ShuttleCityToCityBloc shuttleCityToCityBloc;
  CurrentUserDependency loggedUser = locator.get<CurrentUserDependency>();
  @override
  void initState() {
    _shuttleFinderBloc = context.read<ShuttleFinderBloc>();
    shuttleCityToCityBloc = context.read<ShuttleCityToCityBloc>();
    _shuttleFinderBloc.add(GetUserCurrentLocation());
    shuttleCityToCityBloc.add(GetAvailableShuttleCities());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$welcomeBack ${loggedUser.userModel.fullName}'),
      ),
      body: BlocListener<ShuttleFinderBloc, ShuttleFinderState>(
        listener: (context, state) {
          if (state is OnShuttleLocationSelectedState) {
            Utils.showShuttleSelectedDialog(
                context: context, cityModel: state.selectedCity);
          } else if (state is ShuttleFinderCurrentUserLocationState) {
            _shuttleFinderBloc.nearByDriversStream.listen((drivers) {
              _shuttleFinderBloc.add(
                  OnNearByShuttleDriversAddedEvent(availableDrivers: drivers));
            });
          } else if (state is RequestNotAcceptedState) {
            Navigator.pop(context);
            Utils.showErrortoast(errorMessage: state.errorMessage);
          } else if (state is ShuttleFinderFailureState) {
            Utils.showErrortoast(errorMessage: state.errorMessage);
          }
        },
        child: BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
          builder: (context, state) {
            log('Shuttle bloc builder state is $state');
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
                    onTap: (latlong) {
                      log('lat ${latlong.latitude}');
                      log('long ${latlong.longitude}');
                    },
                    markers: {..._shuttleFinderBloc.nearByDriverMarker},
                  ),
                  const _ShuttleAvailableCities(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShuttleAvailableCities extends StatelessWidget {
  const _ShuttleAvailableCities();

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    return Positioned(
      bottom: 0,
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<ShuttleCityToCityBloc, ShuttleCityToCityState>(
          builder: (context, state) {
            if (state is ShuttleCityToCityLoadingState) {
              return const CitiesLoadingView();
            } else if (state is ShuttleAvailableCitiesFetchedState) {
              return Row(
                children: List.generate(state.availableCities.length, (i) {
                  if (i == 0) {
                    return ShowCaseWidget(
                        onFinish: () async => availableCitiesIntroCheckout(),
                        builder: (context) {
                          return CityIntroTile(
                            cityModel: state.availableCities[i],
                            showCaseKey: key,
                          );
                        });
                  } else {
                    return AvailableCities(
                      cityModel: state.availableCities[i],
                    );
                  }
                }),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  availableCitiesIntroCheckout() async {
    SharedPrefrencesDependency sharedPrefrencesDependency = locator.get();
    SharedPreferences sharedPreferences =
        sharedPrefrencesDependency.preferences;
    await sharedPreferences.setBool(availableCityIntro, true);
  }
}

class CitiesLoadingView extends StatelessWidget {
  const CitiesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Row(
        children: List.generate(
            3,
            (i) => AvailableCities(
                  cityModel: CityToCityModel(
                      fare: ".......",
                      from: ".......",
                      to: '.......',
                      cityUrl: ""),
                )),
      ),
    );
  }
}
