import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/repositories/autth_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with AuthRepo {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        UserCredential? userCredential = await signInWithEmailAndPassword(
            email: email.text, password: password.text);
        if (userCredential != null) {
          bool isVerified = userCredential.user?.emailVerified ?? false;
          if (isVerified) {
            emit(VerifiedEmailState());
          } else {
            emit(NonVerifiedEmailState());
          }
        } else {
          emit(AuthFailureState(failureMessage: usrNotFnd));
        }
      } on FirebaseAuthException catch (authError) {
        final athError = Utils.firebaseSignInErrors(authError.code);
        emit(AuthFailureState(failureMessage: athError));
      } catch (error) {
        log("gernel error $error");
        emit(AuthFailureState(failureMessage: usrNotFnd));
      }
    });
  }
}
