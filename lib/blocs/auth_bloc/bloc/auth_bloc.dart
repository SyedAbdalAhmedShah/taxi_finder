import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:taxi_finder/repositories/autth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with AuthRepo {
  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        UserCredential? userCredential = await signInWithEmailAndPassword(
            email: event.email, password: event.password);
      } catch (error) {}
    });
  }
}
