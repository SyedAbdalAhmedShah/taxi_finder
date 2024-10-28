part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent {}

sealed class CheckUserAuthentication extends SplashEvent {}
