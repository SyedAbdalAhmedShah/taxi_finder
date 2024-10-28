part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class UserAuthenticatedState extends SplashState {}

final class DriverAuthenticatedState extends SplashState {}

final class RoleNotAuthenticatedState extends SplashState {}

final class SplashFilureState extends SplashState {
  final String errorMessage;

  SplashFilureState({required this.errorMessage});
}
