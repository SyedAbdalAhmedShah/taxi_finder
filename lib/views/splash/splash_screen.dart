import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/splash_bloc/splash_bloc.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/utils/utils.dart';
import 'package:taxi_finder/views/bridge/bridge.dart';
import 'package:taxi_finder/views/driver/driver_home.dart';
import 'package:taxi_finder/views/user/services/services_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SplashBloc>().add(CheckUserAuthentication());
    const colorizeColors = [
      Colors.yellow,
      Colors.white,
    ];

    final colorizeTextStyle = TextStyle(
        fontSize: 32.sp, fontFamily: 'Horizon', fontWeight: FontWeight.w600);
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is DriverAuthenticatedState) {
          context.pushReplacment(const DriverHome());
        } else if (state is UserAuthenticatedState) {
          context.pushReplacment(const ServicesPage());
        } else if (state is RoleNotAuthenticatedState) {
          context.pushReplacment(const BridgeScreen());
        } else if (state is SplashFilureState) {
          Utils.showErrortoast(errorMessage: state.errorMessage);
          Future.delayed(
            const Duration(seconds: 2),
            () => context.pushReplacment(const BridgeScreen()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(seconds: 2),
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Taxi Finder',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
              Gap(5.h),
              const CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
