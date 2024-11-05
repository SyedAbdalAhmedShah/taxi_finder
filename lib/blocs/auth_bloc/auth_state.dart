part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class SuccessfullySignOut extends AuthState {}

final class DriverRejectedState extends AuthState {}

final class SignupSuccessfullState extends AuthState {}

final class VerifiedEmailState extends AuthState {}

final class UserAuthSuccessState extends AuthState {}

final class DriverAuthorizedState extends AuthState {}

final class NonVerifiedEmailState extends AuthState {
  final bool isDriver;

  NonVerifiedEmailState({required this.isDriver});
}

final class SignInSuccessfullyState extends AuthState {}

final class DriverAccountPendingState extends AuthState {}

final class AuthFailureState extends AuthState {
  final String failureMessage;

  AuthFailureState({required this.failureMessage});
}
