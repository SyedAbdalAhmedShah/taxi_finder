import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/components/select_pickup_type_dropdown.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/utils/utils.dart';

class ShuttleBookingDiloagContent extends StatefulWidget {
  final CityToCityModel cityModel;
  const ShuttleBookingDiloagContent({
    required this.cityModel,
    super.key,
  });

  @override
  State<ShuttleBookingDiloagContent> createState() =>
      _ShuttleBookingDiloagContentState();
}

class _ShuttleBookingDiloagContentState
    extends State<ShuttleBookingDiloagContent> {
  SharedPrefrencesDependency sharedPrefrencesDependency = locator.get();
  final formKey = GlobalKey<FormState>();
  final dropIntroKey = GlobalKey();
  final fieldIntroKey = GlobalKey();
  final buttonIntroKey = GlobalKey();

  TextEditingController numberOfSeats = TextEditingController();
  late ShuttleFinderBloc shuttleFinderBloc;

  @override
  void initState() {
    shuttleFinderBloc = context.read<ShuttleFinderBloc>();
    checkBookingIntroCheckout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: () => context.pop(), icon: Icon(Icons.close)),
          Gap(5.h),
          Row(
            children: [
              Text(
                'From: ',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              Text(
                '${widget.cityModel.from} ',
                style: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Gap(1.h),
          Row(
            children: [
              Text(
                'To: ',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              Text(
                '${widget.cityModel.to} ',
                style: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Gap(1.h),
          Row(
            children: [
              Text(
                'Cost: ',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              Text(
                '${widget.cityModel.fare} ',
                style: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Gap(1.h),
          Gap(1.h),
          Showcase(
              key: dropIntroKey,
              targetBorderRadius: BorderRadius.circular(8),
              description:
                  "You can select option, You can go to town for taking your ride Or you can choose pick from your location ",
              child: CustomDropdown()),
          Gap(1.h),
          Showcase(
            key: fieldIntroKey,
            description: "You can enter number of seats you want to book",
            targetBorderRadius: BorderRadius.circular(8),
            child: AppTextField(
                keyboardType: TextInputType.number,
                fillColor: Colors.grey.shade700,
                hintText: seatWantToRes,
                validator: (p0) => p0 == null || p0.isEmpty
                    ? "Please enter seats you want to book"
                    : null,
                controller: numberOfSeats),
          ),
          Gap(1.h),
          Showcase(
            key: buttonIntroKey,
            description: "You can send request and book your ride",
            targetBorderRadius: BorderRadius.circular(3.w),
            onBarrierClick: onIntroTap,
            onTargetClick: onIntroTap,
            onToolTipClick: onIntroTap,
            disposeOnTap: true,
            child: PrimaryButton(
                text: bookRide,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    shuttleFinderBloc.add(OnBookShuttleRide(
                        selectedCity: widget.cityModel,
                        numOfSeats: numberOfSeats.text));
                  }
                }),
          ),
          Gap(5.h),
        ],
      ),
    );
  }

  Future onIntroTap() async {
    Navigator.of(context).pop();
    Utils.showNearByDriversDialogIntro(context);
  }

  checkBookingIntroCheckout() {
    SharedPreferences preferences = sharedPrefrencesDependency.preferences;
    bool? bookingRideIntro = preferences.getBool(bookingShuttleRideIntro);

    if (bookingRideIntro == null || !bookingRideIntro) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([dropIntroKey, fieldIntroKey, buttonIntroKey]));
    }
  }
}
