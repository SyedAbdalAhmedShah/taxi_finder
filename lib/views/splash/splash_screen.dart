import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/splash_bloc/splash_bloc.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/utils/utils.dart';
import 'package:taxi_finder/views/driver/auth/pending_screen.dart';
import 'package:taxi_finder/views/bridge/bridge.dart';
import 'package:taxi_finder/views/driver/shuttle_finder/shuttle_finder_driver_home.dart';
import 'package:taxi_finder/views/driver/taxi_finder_service/driver_home.dart';
import 'package:taxi_finder/views/driver/auth/rejected_screen.dart';
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
          CurrentUserDependency loggedUser = locator.get();
          String currentDriverType = loggedUser.driverInfo.driverType ??
              FirebaseStrings.taxiFinderType;
          if (currentDriverType == FirebaseStrings.shuttleServiceType) {
            context.pushReplacment(const ShuttleFinderDriverHome());
          } else {
            context.pushReplacment(const TaxiFinderDriverHome());
          }
        } else if (state is UserAuthenticatedState) {
          context.pushReplacment(const ServicesPage());
        } else if (state is RoleNotAuthenticatedState) {
          context.pushReplacment(const BridgeScreen());
        } else if (state is DriverRejectedState) {
          context.pushReplacment(const RejectedScreen());
        } else if (state is DriverPendingState) {
          context.pushReplacment(const PendingScreen());
        } else if (state is SplashFilureState) {
          Utils.showErrortoast(errorMessage: state.errorMessage);
          Future.delayed(
            const Duration(seconds: 2),
            // ignore: use_build_context_synchronously
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
