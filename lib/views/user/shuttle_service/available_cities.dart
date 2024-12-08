import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/cache_network_image_view.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/utils.dart';

class AvailableCities extends StatelessWidget {
  const AvailableCities({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CacheNetworkImageView(
              width: 30.w,
              cachedNetworkImageHeight: 15.h,
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/taxi-finder-93d36.appspot.com/o/cityPictures%2FMandela_Bridge%2C_Johannesburg%2C_Gauteng%2C_South_Africa.jpg?alt=media&token=f5b17548-4f42-46e1-8bc5-e1793598cbcd',
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
                    Text("Peshawar")
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
                    Text("Peshawar")
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
                    Text("R320")
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
