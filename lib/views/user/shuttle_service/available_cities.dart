import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/components/cache_network_image_view.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';

class AvailableCities extends StatelessWidget {
  final CityToCityModel cityModel;

  const AvailableCities({
    super.key,
    required this.cityModel,
  });

  @override
  Widget build(BuildContext context) {
    return City(cityModel: cityModel);
  }
}

class CityIntroTile extends StatefulWidget {
  final CityToCityModel cityModel;
  final GlobalKey<State<StatefulWidget>> showCaseKey;

  const CityIntroTile(
      {required this.cityModel, required this.showCaseKey, super.key});

  @override
  State<CityIntroTile> createState() => _CityIntroTileState();
}

class _CityIntroTileState extends State<CityIntroTile> {
  SharedPrefrencesDependency sharedPrefrencesDependency = locator.get();
  @override
  void initState() {
    checkIntroIsCheckout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Showcase(
        key: widget.showCaseKey,
        targetBorderRadius: BorderRadius.circular(2.w),
        description: 'You can choose city from this tile where you want to go',
        child: City(cityModel: widget.cityModel));
  }

  checkIntroIsCheckout() async {
    SharedPreferences preferences = sharedPrefrencesDependency.preferences;
    bool? availbelCityIntroChecked = preferences.getBool(availableCityIntro);
    log('availbelCityIntroChecked $availbelCityIntroChecked');
    if (availbelCityIntroChecked == null || !availbelCityIntroChecked) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context).startShowCase([widget.showCaseKey]));
    }
  }
}

class City extends StatelessWidget {
  const City({
    super.key,
    required this.cityModel,
  });

  final CityToCityModel cityModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<ShuttleFinderBloc>()
            .add(OnShuttleSelectLocation(selectedCity: cityModel));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
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
      ),
    );
  }
}
