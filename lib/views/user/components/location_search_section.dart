import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/constants/app_colors.dart';

class LocationSearchSection extends StatelessWidget {
  const LocationSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Light grey shadow color
          spreadRadius: 1, // Spread of the shadow
          blurRadius: 5, // Blur radius for a soft shadow
          offset:
              const Offset(0, 3), // Horizontal offset (0), Vertical offset (3)
        ),
      ], color: primaryColor),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              hintText: "Your Location",
              controller: TextEditingController(),
              fillColor: Colors.white,
            ),
            Gap(1.h),
            AppTextField(
              hintText: "Destination",
              controller: TextEditingController(),
              fillColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
