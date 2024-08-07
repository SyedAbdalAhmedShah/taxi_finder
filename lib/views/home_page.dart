
import 'package:flutter/material.dart';
import 'package:taxi_finder/views/map_view.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [MapSample()],
      ),
    );
  }
}
