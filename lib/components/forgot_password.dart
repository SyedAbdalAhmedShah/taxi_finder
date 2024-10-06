import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';


class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password functionality
        },
        child: Text(
          forgotPassword,
          style: TextStyle(
            color: textColorSecondary,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
