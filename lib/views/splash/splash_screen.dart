import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.yellow,
      Colors.white,
    ];

    final colorizeTextStyle = TextStyle(
        fontSize: 32.sp, fontFamily: 'Horizon', fontWeight: FontWeight.w600);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
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
    );
  }
}
