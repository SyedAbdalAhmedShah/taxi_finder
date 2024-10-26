import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taxi_finder/constants/app_strings.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            emailNotVerified,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
