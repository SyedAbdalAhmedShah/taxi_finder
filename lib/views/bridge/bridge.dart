import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';

import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/views/auth/sign_in_view.dart';

class BridgeScreen extends StatelessWidget {
  const BridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                whoUR,
                style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Gap(3.h),
              SelectorCard(
                imagePaht: driverImage,
                name: "Driver",
                onTap: () => context.push(const SignInView(
                  isDriver: true,
                )),
              ),
              Gap(2.h),
              Text(
                "OR",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
              ),
              Gap(2.h),
              SelectorCard(
                imagePaht: userImage,
                name: "User",
                onTap: () => context.push(const SignInView()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectorCard extends StatelessWidget {
  final String imagePaht;
  final String name;
  final Function()? onTap;
  const SelectorCard(
      {required this.imagePaht, required this.name, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(color: Colors.white, width: 0.5.w)),
        child: Column(
          children: [
            CircleAvatar(
              radius: 12.w / (2) * pi,
              backgroundImage: AssetImage(imagePaht),
            ),
            Gap(1.h),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 22.sp),
            )
          ],
        ),
      ),
    );
  }
}
