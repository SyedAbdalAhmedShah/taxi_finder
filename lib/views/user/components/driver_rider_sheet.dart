import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/cache_network_image_view.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';

class DriverRiderSheet extends StatelessWidget {
  final DriverInfo driverInfo;
  const DriverRiderSheet({required this.driverInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.w), topRight: Radius.circular(5.w)),
      child: DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) => Container(
                color: Colors.grey.shade400,
                padding: EdgeInsets.all(6.w),
                width: double.infinity,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        urRider,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Gap(1.h),
                      const Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CacheNetworkImageView(
                              height: 10.h,
                              imageUrl: driverInfo.profileUrl ?? ""),
                          Gap(2.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Car: ${driverInfo.companyName}"),
                              Gap(1.h),
                              Text("Car Model: ${driverInfo.carModel}"),
                              Gap(1.h),
                              Text("Car number: ${driverInfo.carRegNumber}"),
                              Gap(1.h),
                              Text("Car color: ${driverInfo.carColor}"),
                            ],
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              )),
    );
  }
}
