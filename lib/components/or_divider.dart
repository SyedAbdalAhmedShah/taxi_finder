import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: textColorSecondary,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            orContinueWith,
            style: TextStyle(
              color: textColorSecondary,
              fontSize: 12.sp,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: textColorSecondary,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
