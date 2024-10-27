import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/repositories/autth_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with AuthRepo {
  final TextEditingController email = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController password = TextEditingController();

  final signupFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();
  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        UserCredential? userCredential = await signInWithEmailAndPassword(
            email: email.text, password: password.text);
        if (userCredential != null) {
          bool isVerified = userCredential.user?.emailVerified ?? false;
          if (isVerified) {
            //check if driver or user
            log("is driver ${event.isDriver}");
            // if driver
            if (event.isDriver) {
              DriverInfo? driverInfo =
                  await getDriverData(userCredential.user?.uid ?? "");
              if (driverInfo != null) {
                String status = driverInfo.status ?? "";
                if (status == FirebaseStrings.pending) {
                  emit(DriverAccountPendingState());
                } else {
                  // drriver account accepted state
                }
              } else {
                emit(AuthFailureState(failureMessage: drvrNotFnd));
              }
            } else {
              UserModel? userModel =
                  await getUserDataa(uid: userCredential.user?.uid ?? "");
              if (userModel != null) {
                emit(UserAuthSuccessState());
              } else {
                emit(AuthFailureState(failureMessage: usrNotFnd));
              }
              // user sign in
            }
          } else {  
            await userCredential.user?.sendEmailVerification();
            emit(NonVerifiedEmailState(isDriver: event.isDriver));
          }
        } else {
          emit(AuthFailureState(failureMessage: usrNotFnd));
        }
      } on FirebaseAuthException catch (authError) {
        final athError = Utils.firebaseSignInErrors(authError.code);
        emit(AuthFailureState(failureMessage: athError));
      } catch (error) {
        log("gernel error $error", name: "sign in event");
        emit(AuthFailureState(failureMessage: usrNotFnd));
      }
    });

    on<SignupEvent>(
      (event, emit) async {
        emit(AuthLoadingState());
        try {
          UserCredential? userCredential = await createUserWithEmailAndPass(
              email: email.text.trim(), password: password.text.trim());
          const geoPoint = GeoPoint(-80, 80);
          if (userCredential != null) {
            final uid = userCredential.user?.uid ?? "";
            final data = {
              FirebaseStrings.fullName: fullName.text,
              FirebaseStrings.email: email.text,
              FirebaseStrings.uid: uid,
              FirebaseStrings.currentLocation: geoPoint
            };
            await storeUserDatee(uid: uid, data: data);

            emit(SignupSuccessfullState());
          }
        } on FirebaseAuthException catch (authError) {
          final athError = Utils.firebaseSignInErrors(authError.code);
          emit(AuthFailureState(failureMessage: athError));
        } catch (error) {
          log("gernel error $error", name: "sign up event");
          emit(AuthFailureState(failureMessage: somethingwrong));
        }
      },
    );
  }
}
