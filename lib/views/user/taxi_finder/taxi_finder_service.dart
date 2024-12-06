import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/taxi_finder_bloc/taxi_finder_user_bloc.dart';
import 'package:taxi_finder/constants/enums.dart';
import 'package:taxi_finder/views/user/components/driver_rider_sheet.dart';

import 'package:taxi_finder/views/user/components/location_search_section.dart';
import 'package:taxi_finder/views/user/components/request_sheet.dart';
import 'package:taxi_finder/views/user/taxi_finder/map_view.dart';

class TaxiFinderscreen extends StatefulWidget {
  final ServiceSelected selectedService;
  const TaxiFinderscreen({required this.selectedService, super.key});

  @override
  State<TaxiFinderscreen> createState() => _TaxiFinderscreenState();
}

class _TaxiFinderscreenState extends State<TaxiFinderscreen> {
  late TaxiFinderUserBloc userMapBloc;

  @override
  void initState() {
    // checkLocationPermission();
    userMapBloc = context.read<TaxiFinderUserBloc>();
    userMapBloc.add(FetchCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Stack(
          children: [
            UserMapView(),
            LocationSearchSection(),
          ],
        ),
        bottomSheet: BlocBuilder<TaxiFinderUserBloc, TaxiFinderUserState>(
            builder: (context, state) {
          if (state is OnDirectionRequestState) {
            return RequestSheet(
              selectedService: widget.selectedService,
              totalLocationDistance: state.totalLocationDistance,
              totalfare: state.totalFare,
            );
          } else if (state is OnRideRequestAcceptState) {
            return DriverRiderSheet(
              driverInfo: state.driverInfo,
            );
          } else {
            return const SizedBox.shrink();
          }
        }));
  }
}
