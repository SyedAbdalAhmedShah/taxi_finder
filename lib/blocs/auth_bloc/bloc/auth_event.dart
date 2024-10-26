part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInEvent extends AuthEvent {
  final bool isDriver;

  SignInEvent({required this.isDriver});
}

class SignupEvent extends AuthEvent {}
