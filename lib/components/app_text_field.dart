import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taxi_finder/constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? fillColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function(PointerDownEvent)? onTapOutside;
  const AppTextField({
    super.key,
    required this.hintText,
    this.fillColor,
    this.prefixIcon,
    this.keyboardType,
    this.onTapOutside,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    required this.controller,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool isPassword;
  final key = GlobalKey();

  @override
  void initState() {
    isPassword = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: key,
      description: "Enter number of seats you want to book",
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: isPassword,
        keyboardType: widget.keyboardType,
        onTapOutside: widget.onTapOutside,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? textColorSecondary.withOpacity(0.1),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: widget.fillColor == Colors.white
                  ? textColorSecondary
                  : Colors.white),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: textColorSecondary,
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? InkWell(
                  onTap: () => setState(() {
                        isPassword = !isPassword;
                      }),
                  child: Icon(widget.suffixIcon, color: textColorSecondary))
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
            color:
                widget.fillColor == Colors.white ? Colors.black : Colors.white),
      ),
    );
  }
}
