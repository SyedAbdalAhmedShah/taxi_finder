import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';
import 'package:taxi_finder/repositories/autth_repo.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> with AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SplashBloc() : super(SplashInitial()) {
    on<CheckUserAuthentication>((event, emit) async {
      await DependencySetup.setupDependencies();

      final sharedPrefDep = locator.get<SharedPrefrencesDependency>();
      final loggedRole = locator.get<CurrentUserDependency>();
      final currentUser = _auth.currentUser;
      try {
        bool? isDriver =
            sharedPrefDep.preferences.getBool(FirebaseStrings.driverStoreKey);
        if (currentUser != null) {
          if (isDriver != null && isDriver) {
            DriverInfo? driverInfo = await getDriverData(currentUser.uid);
            if (driverInfo != null) {
              loggedRole.setDriver(driverInfo);
              emit(DriverAuthenticatedState());
            } else {
              await _auth.signOut();
              emit(SplashFilureState(errorMessage: logout));
            }
          } else {
            UserModel? userModel = await getUserDataa(uid: currentUser.uid);
            if (userModel != null) {
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
      } catch (error) {
        log("error happened $error");
        if (currentUser != null) _auth.signOut();
        emit(SplashFilureState(errorMessage: logout));
      }
    });
  }
}