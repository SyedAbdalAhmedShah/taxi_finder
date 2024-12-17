import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/taxi_finder_bloc/taxi_finder_user_bloc.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/views/user/components/auto_complete_map_field.dart';

class LocationSearchSection extends StatefulWidget {
  const LocationSearchSection({super.key});

  @override
  State<LocationSearchSection> createState() => _LocationSearchSectionState();
}

class _LocationSearchSectionState extends State<LocationSearchSection> {
  GlobalKey one = GlobalKey();
  GlobalKey two = GlobalKey();
  late TaxiFinderUserBloc userMapBloc;
  SharedPrefrencesDependency sharedPrefrencesDependency = locator.get();
  @override
  void initState() {
    userMapBloc = context.read<TaxiFinderUserBloc>();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await showShowCaseWidget());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<TaxiFinderUserBloc, TaxiFinderUserState>(
          builder: (context, state) {
            return state is UserMapLoadingState ||
                    userMapBloc.countryISO == null
                ? const SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Showcase(
                        key: one,
                        description: 'Your current location',
                        targetBorderRadius: BorderRadius.circular(8),
                        child: AutoCompleteMapField(
                          countryISO: userMapBloc.countryISO!,
                          controller: userMapBloc.myLocationController,
                          hint: "Your Location",
                          // onLocationSelected: (prediction) {},
                        ),
                      ),
                      Gap(1.h),
                      Showcase(
                        key: two,
                        onBarrierClick: () async =>
                            await storeIntroKey(taxiFinderMyLocKey),
                        onTargetClick: () async =>
                            await storeIntroKey(taxiFinderMyLocKey),
                        onToolTipClick: () async =>
                            await storeIntroKey(taxiFinderMyLocKey),
                        disposeOnTap: true,
                        description: 'The destination location you want to go',
                        targetBorderRadius: BorderRadius.circular(8),
                        child: Autocomplete(
                          optionsViewBuilder: (context, onSelected, options) {
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
                            FocusScope.of(context).unfocus();
                            userMapBloc.add(
                                OnLocationSelectedEvent(prediction: option));
                          },
                          displayStringForOption: (option) =>
                              option.description ?? "",
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            return TextField(
                              focusNode: focusNode,
                              onEditingComplete: onFieldSubmitted,
                              onSubmitted: (value) {
                                focusNode.unfocus();
                              },
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  hintText: "Destination",
                                  hintStyle: const TextStyle(
                                      color: textColorSecondary),
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
                        ),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }

  storeIntroKey(String key) async {
    await sharedPrefrencesDependency.preferences.setBool(key, true);

    ShowCaseWidget.of(context).next();
  }

  showShowCaseWidget() async {
    SharedPreferences prefrences = sharedPrefrencesDependency.preferences;

    bool? taxiFinderIntro = prefrences.getBool(taxiFinderMyLocKey);

    if (taxiFinderIntro == null) {
      ShowCaseWidget.of(context).startShowCase([one, two]);
    }
  }
}
