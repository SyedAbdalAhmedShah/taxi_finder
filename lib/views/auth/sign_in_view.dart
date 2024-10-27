import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/components/signup_prompt.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/utils/utils.dart';
import 'package:taxi_finder/utils/validator.dart';
import 'package:taxi_finder/views/auth/email_not_verified.dart';
import 'package:taxi_finder/views/auth/pending_screen.dart';
import 'package:taxi_finder/views/auth/sign_up_view.dart';
import 'package:taxi_finder/views/user/map_view/home_page.dart';

import '../../components/forgot_password.dart';

class SignInView extends StatelessWidget {
  final bool isDriver;
  const SignInView({this.isDriver = false, super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      fontSize: 16.sp,
                      color: textColorSecondary,
                    ),
                  ),
                  AppTextField(
                    validator: Validator.emailValidator,
                    controller: authBloc.email,
                    hintText: enterEmail,
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
                    obscureText: true,
                    controller: authBloc.password,
                    validator: Validator.passwordValidator,
                    hintText: enterPassword,
                    prefixIcon: Icons.email,
                    suffixIcon: Icons.visibility_off,
                  ),
                  Gap(2.h),
                  const ForgotPassword(),
                  Gap(3.h),
                  _SignInButtonStates(
                    isDriver: isDriver,
                  ),
                  Gap(5.h),
                  Visibility(
                    visible: !isDriver,
                    child: SignupPrompt(
                      onPressed: () {
                        context.push(const SignUpView());
                      },
                      text: signUp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButtonStates extends StatelessWidget {
  final bool isDriver;
  const _SignInButtonStates({required this.isDriver, super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureState) {
          Utils.showErrortoast(errorMessage: state.failureMessage);
        } else if (state is NonVerifiedEmailState) {
          context.pushAndRemoveUntil(EmailNotVerified(
            isDriver: state.isDriver,
          ));
        } else if (state is DriverAccountPendingState) {
          context.push(const PendingScreen());
        } else if (state is UserAuthSuccessState) {
          context.pushAndRemoveUntil(const MyHomePage());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return PrimaryButton(
            text: signIn,
            showLoader: state is AuthLoadingState,
            onPressed: () {
              authBloc.add(SignInEvent(isDriver: isDriver));
            },
          );
        },
      ),
    );
  }
}
