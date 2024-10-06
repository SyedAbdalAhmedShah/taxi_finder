import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/logo_image.dart';
import 'package:taxi_finder/components/or_divider.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/components/secondary_button.dart';
import 'package:taxi_finder/components/signup_prompt.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/views/auth/sign_up_view.dart';

import '../../components/forgot_password.dart';


class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoImage(
                    size: 14.h,
                  ),
                ],
              ),
              Gap(2.h),
              Text(
                welcomeBack,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Gap(2.h),
              Text(
                email,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColorSecondary,
                ),
              ),
              const AppTextField(
                hintText: enterEmail,
                prefixIcon: Icons.email,
              ),
              Gap(3.h),
              Text(
                email,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColorSecondary,
                ),
              ),
              const AppTextField(
                hintText: password,
                prefixIcon: Icons.email,
                suffixIcon: Icons.visibility_off,
              ),
              Gap(2.h),
              const ForgotPassword(),
              Gap(3.h),
              PrimaryButton(
                text: signIn,
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
                  context.push(const SignUpView());
                },
                text: signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
