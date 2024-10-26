import 'dart:developer';

class Utils {
static  String firebaseSignInErrors(String code) {
    final errorMessage = switch (code) {
      ('invalid-email') => 'Invalid email format.',
      ('user-not-found') => 'No user found with this email.',
      ('wrong-password') => 'Incorrect password.',
      ('user-disabled') => 'User account is disabled.',
      (_) => 'An undefined error occurred: ',
    };
    log('firebase errror $code');
    return errorMessage;
  }
}
