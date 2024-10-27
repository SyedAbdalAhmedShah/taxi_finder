import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class Utils {
  static String firebaseSignInErrors(String code) {
    final errorMessage = switch (code) {
      ('invalid-email') => 'Invalid email format.',
      ('user-not-found') => 'No user found with this email.',
      ('wrong-password') => 'Incorrect password.',
      ('user-disabled') => 'User account is disabled.',
      ('network-request-failed') => "Please check your internet connection",
      ('invalid-credential') => " Username or password is incorrect",
      (_) => 'An undefined error occurred: ',
    };
    log('firebase errror $code');
    return errorMessage;
  }

  static showErrortoast({required String errorMessage}) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0.sp);
  }
}
