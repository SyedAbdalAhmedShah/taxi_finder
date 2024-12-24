import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/secondary_button.dart';
import 'package:taxi_finder/constants/app_colors.dart';

import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/views/user/shuttle_service/shuttle_service.dart';

class IntroductionShuttleService extends StatelessWidget {
  const IntroductionShuttleService({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.7),
            primaryColor.withOpacity(0.5),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          minimum: EdgeInsets.only(
            top: 8.h,
            left: 2.w,
            right: 2.w,
          ),
          top: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AvailableTipsSection(),
                Gap(5.h),
                _CityIntroSection(
                  city: limpopo,
                  color: Colors.green,
                ),
                Gap(5.h),
                RotatedBox(
                  quarterTurns: 1,
                  child: const BidirectionalArrow(
                    width: 230,
                    height: 50,
                    color: Colors.orange,
                    arrowHeadWidth: 20,
                  ),
                ),
                Gap(5.h),
                _CityIntroSection(
                  city: gauteng,
                  color: Colors.orange,
                ),
                Gap(5.h),
                SecondaryButton(
                    text: "Continue to Book Ride",
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ShuttleService(),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailableTipsSection extends StatelessWidget {
  const _AvailableTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        availTips,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black45,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CityIntroSection extends StatelessWidget {
  final String city;
  final Color color;
  const _CityIntroSection({required this.city, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.w,
      backgroundColor: color,
      child: Text(
        city,
        style: TextStyle(
            color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class BidirectionalArrow extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double arrowHeadWidth;

  const BidirectionalArrow({
    super.key,
    this.width = 200,
    this.height = 40,
    this.color = Colors.orange,
    this.arrowHeadWidth = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: BidirectionalArrowPainter(
        color: color,
        arrowHeadWidth: arrowHeadWidth,
      ),
    );
  }
}

class BidirectionalArrowPainter extends CustomPainter {
  final Color color;
  final double arrowHeadWidth;

  BidirectionalArrowPainter({
    required this.color,
    required this.arrowHeadWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Left arrow head
    path.moveTo(0, size.height / 2);
    path.lineTo(arrowHeadWidth, 0);
    path.lineTo(arrowHeadWidth, size.height * 0.25);

    // Main body (horizontal)
    path.lineTo(size.width - arrowHeadWidth, size.height * 0.25);

    // Right arrow head
    path.lineTo(size.width - arrowHeadWidth, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - arrowHeadWidth, size.height);
    path.lineTo(size.width - arrowHeadWidth, size.height * 0.75);

    // Complete main body
    path.lineTo(arrowHeadWidth, size.height * 0.75);

    // Complete left arrow head
    path.lineTo(arrowHeadWidth, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
