import 'package:firebase_auth/firebase_auth.dart';

mixin AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }
}
