import 'package:flutter/material.dart';
import 'package:taxi_finder/constants/app_colors.dart';



class AppTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: textColorSecondary.withOpacity(0.1),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(
          prefixIcon,
          color: textColorSecondary,
        ),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: textColorSecondary)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
