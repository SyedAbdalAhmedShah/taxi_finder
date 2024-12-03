import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/repositories/autth_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> with AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SplashBloc() : super(SplashInitial()) {
    on<CheckUserAuthentication>((event, emit) async {
      final sharedPrefDep = locator.get<SharedPrefrencesDependency>();
      final loggedRole = locator.get<CurrentUserDependency>();
      final currentUser = _auth.currentUser;
      // try {
      bool? isDriver =
          sharedPrefDep.preferences.getBool(FirebaseStrings.driverStoreKey);
      log("IS driver  $isDriver");
      log('current User is ${currentUser?.uid}');
      if (currentUser != null) {
        if (isDriver != null && isDriver) {
          DriverInfo? driverInfo =
              await Utils.updateDriver(driverUid: currentUser.uid);
          if (driverInfo != null) {
            loggedRole.setDriver(driverInfo);
            if (driverInfo.status == FirebaseStrings.approved) {
              emit(DriverAuthenticatedState());
            } else if (driverInfo.status == FirebaseStrings.pending) {
              emit(DriverPendingState());
            } else {
              emit(DriverRejectedState());
            }
          } else {
            await _auth.signOut();
            emit(SplashFilureState(errorMessage: logout));
          }
        } else {
          UserModel? userModel = await getUserDataa(uid: currentUser.uid);
          if (userModel != null) {
            await updateUserFcmTokenAndDeviceId(currentUser.uid);
            loggedRole.setUser(userModel);
            emit(UserAuthenticatedState());
          } else {
            await _auth.signOut();
            emit(SplashFilureState(errorMessage: logout));
          }
        }
      } else {
        emit(RoleNotAuthenticatedState());
      }
      // } catch (error) {
      //   log("error happened $error");
      //   if (currentUser != null) _auth.signOut();
      //   emit(SplashFilureState(errorMessage: logout));
      // }
    });
  }
}
