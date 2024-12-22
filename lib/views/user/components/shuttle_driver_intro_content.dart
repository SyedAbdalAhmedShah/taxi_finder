import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/near_by_driver_shuttler.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/utils/extensions.dart';

class ShuttleDriverIntroContent extends StatefulWidget {
  const ShuttleDriverIntroContent({super.key});

  @override
  State<ShuttleDriverIntroContent> createState() =>
      _ShuttleDriverIntroContentState();
}

class _ShuttleDriverIntroContentState extends State<ShuttleDriverIntroContent> {
  final driverInfoIntro = GlobalKey();
  final requestAllItro = GlobalKey();
  SharedPrefrencesDependency sharedPrefrencesDependency = locator.get();
  @override
  void initState() {
    checkShuttleDriverIntro();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
      child: Column(
        children: [
          Gap(2.h),
          Showcase(
            key: driverInfoIntro,
            description:
                "You can see available drivers information and send a request to a particular driver ",
            targetBorderRadius: BorderRadius.circular(2.w),
            child: NearByDriverShuttler(
                noSeatsWantToBook: "2",
                selectedCity: CityToCityModel(),
                driverUid: "123",
                requestId: "123",
                carNumber: "912",
                departureTime: "08:00 PM",
                driverName: "Micheal",
                driverPicUrl:
                    "https://firebasestorage.googleapis.com/v0/b/taxi-finder-93d36.appspot.com/o/uploads%2Fman-pointing-his-left.jpg?alt=media&token=d6d9cb69-fd38-4e6f-8f6d-3c09848e9c5c",
                numberOfSeatAvailable: "2"),
          ),
          Gap(2.h),
          NearByDriverShuttler(
              noSeatsWantToBook: "2",
              carNumber: "1002",
              selectedCity: CityToCityModel(),
              driverUid: "123",
              requestId: "123",
              departureTime: "12:00 PM",
              driverName: "Mike",
              driverPicUrl:
                  "https://firebasestorage.googleapis.com/v0/b/taxi-finder-93d36.appspot.com/o/uploads%2Fman-pointing-his-left.jpg?alt=media&token=d6d9cb69-fd38-4e6f-8f6d-3c09848e9c5c",
              numberOfSeatAvailable: "2"),
          Gap(2.h),
          NearByDriverShuttler(
              noSeatsWantToBook: "2",
              carNumber: "612",
              selectedCity: CityToCityModel(),
              driverUid: "123",
              requestId: "123",
              departureTime: "10:00 PM",
              driverName: "John wick",
              driverPicUrl:
                  "https://firebasestorage.googleapis.com/v0/b/taxi-finder-93d36.appspot.com/o/uploads%2Fman-pointing-his-left.jpg?alt=media&token=d6d9cb69-fd38-4e6f-8f6d-3c09848e9c5c",
              numberOfSeatAvailable: "2"),
          Spacer(),
          Showcase(
              key: requestAllItro,
              description:
                  "You can also send request at once to all available drivers",
              targetBorderRadius: BorderRadius.circular(3.w),
              child: PrimaryButton(text: "Request To All", onPressed: () {})),
          Gap(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                  onPressed: () => context.pop(), child: Text("Cancel"))
            ],
          ),
          Gap(2.h),
        ],
      ),
    );
  }

  checkShuttleDriverIntro() {
    SharedPreferences preferences = sharedPrefrencesDependency.preferences;
    bool? shuttleDriverIntro = preferences.getBool(shuttleRequestDriverIntro);
    if (shuttleDriverIntro == null || !shuttleDriverIntro) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([driverInfoIntro, requestAllItro]));
    }
  }
}
