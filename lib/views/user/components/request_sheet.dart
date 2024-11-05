import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/utils/validator.dart';

class RequestSheet extends StatelessWidget {
  const RequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    UserMapBloc userMapBloc = context.read<UserMapBloc>();
    final key = GlobalKey<FormState>();
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.w), topRight: Radius.circular(5.w)),
      child: BlocBuilder<UserMapBloc, UserMapState>(
        builder: (context, state) {
          return DraggableScrollableSheet(
            initialChildSize: userMapBloc.showRequestSheet ? 0.3 : 0.0,
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
                            "Total distance:",
                            style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp),
                          ),
                          Gap(2.w),
                          Text(userMapBloc.totalLocationDistance,
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
                            "Total Fears:",
                            style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp),
                          ),
                          Gap(2.w),
                          Text("${userMapBloc.totalfare}R",
                              style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp))
                        ],
                      ),
                      Gap(1.h),
                      Form(
                        key: key,
                        child: AppTextField(
                            validator: Validator.emptyAndGreaterZerogValidator,
                            keyboardType: TextInputType.number,
                            fillColor: Colors.white,
                            hintText: "Total seat you want to book",
                            onTapOutside: (p0) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: userMapBloc.totalSeatBookController),
                      ),
                      Gap(1.h),
                      PrimaryButton(
                          text: "Request",
                          onPressed: () {
                            if (key.currentState?.validate() ?? false) {}
                          })
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
