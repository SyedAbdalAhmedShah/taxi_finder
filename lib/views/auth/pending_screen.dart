import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/extensions.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            accountPending,
          ),
          Gap(5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Text(
              pendingStatusDriver,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ),
          Gap(5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: PrimaryButton(
              text: back,
              onPressed: () => context.pop(),
            ),
          )
        ],
      ),
    );
  }
}
