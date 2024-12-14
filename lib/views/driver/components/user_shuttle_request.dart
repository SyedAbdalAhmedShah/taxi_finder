import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';

class UserShuttleRequestCard extends StatelessWidget {
  const UserShuttleRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor.withRed(200),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearTimer(
              duration: const Duration(seconds: 10),
              backgroundColor: primaryColor,
              onTimerEnd: () {
                // context.read<DriverTaxiFinderBLoc>().add(OnRequestExpireEvent(
                //     docId: userRequestModel.requestId ?? ""));
              },
            ),
            Gap(1.h),
            RichText(
              text: TextSpan(
                  text: "From  ",
                  children: [
                    TextSpan(
                        text: "Peshawar ",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp))
                  ],
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.0.w, top: 1.h, bottom: 1.h),
              child: ColoredBox(
                color: Colors.red,
                child: SizedBox(
                  width: 0.3.w,
                  height: 5.h, // Adjust height to the desired length
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: "To  ",
                      children: [
                        TextSpan(
                            text: "Islamabad",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp))
                      ],
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                ),
                Row(
                  children: [
                    Text(
                      "Fare: ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text("R150 "),
                  ],
                ),
              ],
            ),
            Gap(1.h),
            Text('Pick from user location'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // context.read<DriverTaxiFinderBLoc>().add(
                      //     OnAcceptRide(userRequestModel: userRequestModel));
                    },
                    child: const Text("Accept"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
