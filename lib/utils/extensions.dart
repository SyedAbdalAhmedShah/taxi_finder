import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get size => MediaQuery.sizeOf(this);
  double get height => size.height;
  double get width => size.width;

  void push(Widget widget) => Navigator.push(
        this,
        MaterialPageRoute(builder: (context) => widget),
      );

  void pop() => Navigator.pop(this);

  void pushAndRemoveUntil(Widget widget) =>
      Navigator.of(this).push(MaterialPageRoute(
        builder: (context) => widget,
      ));
  void pushReplacment(Widget child) =>
      Navigator.of(this).pushReplacement(MaterialPageRoute(
        builder: (context) => child,
      ));
}
