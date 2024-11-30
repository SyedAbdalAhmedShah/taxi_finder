import 'package:flutter/material.dart';

import 'package:taxi_finder/constants/app_assets.dart';

class LogoImage extends StatelessWidget {
  final double size;

  const LogoImage({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logoImage,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
