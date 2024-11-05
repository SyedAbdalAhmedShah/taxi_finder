import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_assets.dart';
import 'package:taxi_finder/constants/app_strings.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Service"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ServiceCard(
              imagePath: taxiFinderImage,
              title: taxiFinderS,
              onTap: () {},
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
              onTap: () {},
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
