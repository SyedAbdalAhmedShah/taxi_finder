import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/forgot_password.dart';
import 'package:taxi_finder/components/or_divider.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/components/secondary_button.dart';
import 'package:taxi_finder/components/signup_prompt.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/extensions.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     LogoImage(
                //       size: 14.h,
                //     ),
                //   ],
                // ),
                Gap(2.h),
                Text(
                  createAccount,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Gap(2.h),
                Text(
                  fullName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColorSecondary,
                  ),
                ),
                AppTextField(
                  hintText: enterFullName,
                  controller: authBloc.fullName,
                  prefixIcon: Icons.person_2_outlined,
                ),
                Gap(2.h),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColorSecondary,
                  ),
                ),
                AppTextField(
                  controller: authBloc.email,
                  hintText: enterEmail,
                  prefixIcon: Icons.email,
                ),
                Gap(3.h),
                Text(
                  password,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColorSecondary,
                  ),
                ),
                AppTextField(
                  controller: authBloc.password,
                  hintText: password,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: Icons.visibility_off,
                ),
                Gap(2.h),
                const ForgotPassword(),
                Gap(3.h),
                PrimaryButton(
                  text: signUp,
                  onPressed: () {},
                ),
                Gap(5.h),
                const OrDivider(),
                Gap(5.h),
                SecondaryButton(
                  text: continueWithGoogle,
                  onPressed: () {},
                ),
                Gap(1.h),
                SignupPrompt(
                  onPressed: () {
                    context.pop();
                  },
                  text: signIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
