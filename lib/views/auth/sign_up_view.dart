import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';

import 'package:taxi_finder/components/primary_button.dart';

import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/utils/validator.dart';
import 'package:taxi_finder/views/auth/sign_in_view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Form(
              key: authBloc.signupFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      fontSize: 16.sp,
                      color: textColorSecondary,
                    ),
                  ),
                  AppTextField(
                    hintText: enterFullName,
                    validator: Validator.emptyStringValidator,
                    controller: authBloc.fullName,
                    prefixIcon: Icons.person_2_outlined,
                  ),
                  Gap(2.h),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColorSecondary,
                    ),
                  ),
                  AppTextField(
                    controller: authBloc.email,
                    hintText: enterEmail,
                    validator: Validator.emailValidator,
                    prefixIcon: Icons.email,
                  ),
                  Gap(3.h),
                  Text(
                    password,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColorSecondary,
                    ),
                  ),
                  AppTextField(
                    controller: authBloc.password,
                    obscureText: true,
                    hintText: password,
                    validator: Validator.passwordValidator,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: Icons.visibility_off,
                  ),
                  Gap(2.h),
                  Gap(3.h),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is SignupSuccessfullState) {
                        context.pushAndRemoveUntil(const SignInView());
                      }
                    },
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          showLoader: state is AuthLoadingState,
                          text: signUp,
                          onPressed: () {
                            if (authBloc.signupFormKey.currentState
                                    ?.validate() ??
                                false) {
                              authBloc.add(SignupEvent());
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Gap(5.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
