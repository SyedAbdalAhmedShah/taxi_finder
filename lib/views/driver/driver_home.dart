import 'package:flutter/material.dart';
import 'package:taxi_finder/components/logout_button.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [LogoutButton()],
      ),
      body: Column(
        children: [Text('HI There ')],
      ),
    );
  }
}
