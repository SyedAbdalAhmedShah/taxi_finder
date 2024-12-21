import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/cache_network_image_view.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_strings.dart';

class NearByDriverShuttler extends StatelessWidget {
  final String driverName;
  final String driverPicUrl;
  final String carNumber;
  final String numberOfSeatAvailable;
  final String departureTime;
  const NearByDriverShuttler(
      {required this.carNumber,
      required this.departureTime,
      required this.driverName,
      required this.driverPicUrl,
      required this.numberOfSeatAvailable,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 1.w),
        child: Wrap(
          spacing: 1.w,
          runSpacing: 1.h,
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DriverTitle(
                  title: driverName,
                ),
                CacheNetworkImageView(
                  imageUrl: driverPicUrl,
                  cachedNetworkImageHeight: 5.h,
                  width: 10.w,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DriverTitle(
                  title: carNum,
                ),
                Text(carNumber)
              ],
            ),
            SizedBox(
              width: 25.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DriverTitle(
                    title: numberOfSeatsAvail,
                  ),
                  Text(numberOfSeatAvailable)
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DriverTitle(
                  title: depTime,
                ),
                Text(departureTime)
              ],
            ),
            PrimaryButton(
              text: "Send Ride Request",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class _DriverTitle extends StatelessWidget {
  final String title;
  const _DriverTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey.shade600),
    );
  }
}
