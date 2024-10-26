import 'package:taxi_finder/constants/app_strings.dart';

class Validator {
  static String? emailValidator(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (value == null || value.isEmpty) {
      return emptyField;
    } else if (!emailRegex.hasMatch(value)) {
      return validEmail;
    } else {
      return null;
    }
  }

  static String? emptyStringValidator(String? value) {
    if (value == null || value.isEmpty) {
      return emptyField;
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return emptyField;
    } else if (value.length <= 8) {
      return passwordValid;
    } else {
      return null;
    }
  }
}
