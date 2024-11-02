import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
                      Autocomplete(
                        optionsViewBuilder: (context, onSelected, options) {
                          log("option  legth ${options.length}");
                          return Card(
                            child: ListView(
                              children: options.map(
                                (prediction) {
                                  return ListTile(
                                    onTap: () {
                                      onSelected(prediction);
                                    },
                                    title: Text(prediction.description ?? ""),
                                  );
                                },
                              ).toList(),
                            ),
                          );
                        },
                        onSelected: (option) {
                          userMapBloc
                              .add(OnLocationSelectedEvent(prediction: option));
                        },
                        displayStringForOption: (option) =>
                            option.description ?? "",
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          return TextField(
                            focusNode: focusNode,
                            onEditingComplete: onFieldSubmitted,
                            controller: textEditingController,
                            decoration: InputDecoration(
                                hintText: "destination",
                                hintStyle:
                                    const TextStyle(color: textColorSecondary),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                )),
                          );
                        },
                        optionsBuilder: (textEditingValue) {
                          userMapBloc.add(OnLocationSearchEvent(
                              query: textEditingValue.text));
                          return userMapBloc.searchLocations;
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
