import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/constants/enums.dart';

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
  late UserMapBloc userMapBloc;

  @override
  void initState() {
    // checkLocationPermission();
    userMapBloc = context.read<UserMapBloc>();
    userMapBloc.add(FetchCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Stack(
          children: [
            MapSample(),
            LocationSearchSection(),
          ],
        ),
        bottomSheet: RequestSheet(
          selectedService: widget.selectedService,
        ));
  }
}
