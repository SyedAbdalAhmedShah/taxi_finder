import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/views/bridge/bridge.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "We Are Apologise from you \n Your Account has been ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              Gap(1.h),
              Text(
                "Rejected",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              Gap(3.h),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is SuccessfullySignOut) {
                    context.pushAndRemoveUntil(const BridgeScreen());
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: PrimaryButton(
                      text: "Back",
                      onPressed: () {
                        context.read<AuthBloc>().add(SignouEvent());
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
