import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/views/auth/sign_in_view.dart';

class EmailNotVerified extends StatelessWidget {
  final bool isDriver;
  const EmailNotVerified({required this.isDriver, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emailNotVerified,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              Gap(5.h),
              Lottie.asset(verificationLottie, onLoaded: (p0) {
// context.read<SubjectBloc>()
                Timer(
                  const Duration(seconds: 5),
                  () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) => SignInView(
                              isDriver: isDriver,
                            )),
                    (route) => false,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
