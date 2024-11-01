import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/views/user/components/location_search_section.dart';
import 'package:taxi_finder/views/user/map_view/map_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return const Scaffold(
        body: Stack(
      children: [
        MapSample(),
        LocationSearchSection(),
      ],
    ));
  }
}
