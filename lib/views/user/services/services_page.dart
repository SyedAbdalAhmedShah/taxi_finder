import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/enums.dart';
import 'package:taxi_finder/utils/extensions.dart';

import 'package:taxi_finder/views/bridge/bridge.dart';
import 'package:taxi_finder/views/user/taxi_finder/taxi_finder_service.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(selectService),
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SuccessfullySignOut) {
                context.pushAndRemoveUntil(const BridgeScreen());
              }
            },
            child: IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignouEvent());
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ServiceCard(
              imagePath: taxiFinderImage,
              title: taxiFinderS,
              onTap: () => context.push(const TaxiFinderscreen(
                selectedService: ServiceSelected.taxiFinder,
              )),
            ),
            Gap(1.h),
            Text(
              "OR",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            Gap(1.h),
            ServiceCard(
              imagePath: shuttleFinderImage,
              title: shuttleFinderS,
              onTap: () {
                // context.push(const TaxiFinderscreen());
              },
            )
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;
  const ServiceCard({
    required this.imagePath,
    required this.title,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4.w),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.w)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 30.h,
              width: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w)),
                image: DecorationImage(
                    image: AssetImage(imagePath), fit: BoxFit.fill),
              ),
            ),
            Gap(1.h),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
            Gap(1.h),
          ],
        ),
      ),
    );
  }
}