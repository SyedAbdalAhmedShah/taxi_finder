import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/cache_network_image_view.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';

class AvailableCities extends StatelessWidget {
  final CityToCityModel cityModel;
  const AvailableCities({super.key, required this.cityModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CacheNetworkImageView(
              width: 30.w,
              cachedNetworkImageHeight: 15.h,
              imageUrl: cityModel.cityUrl ?? "",
              boxDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(2.w)),
            ),
            Gap(1.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 4.w,
                    ),
                    Gap(1.w),
                    Text(cityModel.from ?? "")
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 1.8.w, top: 0.4.h, bottom: 0.4.h),
                  child: ColoredBox(
                    color: primaryColor,
                    child: SizedBox(
                      width: 0.2.w,
                      height: 4.h,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 4.w,
                    ),
                    Gap(1.w),
                    Text(cityModel.to ?? "")
                  ],
                ),
                Gap(1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      cost,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Gap(1.w),
                    Text("R${cityModel.fare}")
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
