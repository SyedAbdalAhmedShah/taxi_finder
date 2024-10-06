import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';

class SignupPrompt extends StatelessWidget {
  final Function() onPressed;
  final String text;
  const SignupPrompt({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          dontHaveAccount,
          style: TextStyle(
            color: textColorSecondary,
            fontSize: 12.sp,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
