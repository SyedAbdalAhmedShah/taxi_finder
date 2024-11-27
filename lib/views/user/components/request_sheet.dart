import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/enums.dart';
import 'package:taxi_finder/utils/validator.dart';

class RequestSheet extends StatelessWidget {
  final ServiceSelected selectedService;
  final String totalLocationDistance;
  final String totalfare;
  const RequestSheet(
      {required this.selectedService,
      required this.totalLocationDistance,
      required this.totalfare,
      super.key});

  @override
  Widget build(BuildContext context) {
    UserMapBloc userMapBloc = context.read<UserMapBloc>();
    final key = GlobalKey<FormState>();
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.w), topRight: Radius.circular(5.w)),
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.0,
        maxChildSize: 0.6,
        shouldCloseOnMinExtent: true,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            color: Colors.grey.shade400,
            padding: EdgeInsets.all(6.w),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        totlDis,
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp),
                      ),
                      Gap(2.w),
                      Text(totalLocationDistance,
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp))
                    ],
                  ),
                  Gap(1.h),
                  Row(
                    children: [
                      Text(
                        cost,
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp),
                      ),
                      Gap(2.w),
                      Text("R${totalfare}",
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp))
                    ],
                  ),
                  Gap(1.h),
                  Visibility(
                    visible: selectedService == ServiceSelected.shuttleFinder,
                    child: Form(
                      key: key,
                      child: AppTextField(
                          validator: Validator.emptyAndGreaterZerogValidator,
                          keyboardType: TextInputType.number,
                          fillColor: Colors.white,
                          hintText: totalSeatToBook,
                          onTapOutside: (p0) {
                            FocusScope.of(context).unfocus();
                          },
                          controller: userMapBloc.totalSeatBookController),
                    ),
                  ),
                  Gap(1.h),
                  PrimaryButton(
                      text: request,
                      onPressed: () {
                        if (selectedService == ServiceSelected.shuttleFinder) {
                          if (key.currentState?.validate() ?? false) {}
                        } else {
                          userMapBloc.add(OnRequestForRiding());
                        }
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
