import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/views/user/components/auto_complete_map_field.dart';

class LocationSearchSection extends StatelessWidget {
  const LocationSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    UserMapBloc userMapBloc = context.read<UserMapBloc>();
    return Container(
      height: 25.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Light grey shadow color
          spreadRadius: 1, // Spread of the shadow
          blurRadius: 5, // Blur radius for a soft shadow
          offset:
              const Offset(0, 3), // Horizontal offset (0), Vertical offset (3)
        ),
      ], color: primaryColor),
      child: SafeArea(
        child: BlocBuilder<UserMapBloc, UserMapState>(
          builder: (context, state) {
            return state is UserMapLoadingState ||
                    userMapBloc.countryISO == null
                ? const SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoCompleteMapField(
                        countryISO: userMapBloc.countryISO!,
                        controller: userMapBloc.myLocationController,
                        hint: "Your Location",
                        // onLocationSelected: (prediction) {},
                      ),
                      Gap(1.h),
                      AutoCompleteMapField(
                        countryISO: userMapBloc.countryISO!,
                        controller: userMapBloc.destinationController,
                        hint: "Destination",
                        onLocationSelected: (place) async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          log("prediction ${place.toString()}");
                          userMapBloc.add(OnDirectionEvent(
                              latLng:
                                  LatLng(place.lat ?? 0.0, place.lng ?? 0.0)));
                        },
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}