import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showLoader;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(3.w),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 7.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.w),
          color: primaryColor,
        ),
        child: showLoader
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
