import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';

mixin AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  Future getDriverDate(String driverUid) async {
    DocumentSnapshot<Map<String, dynamic>> docsnap = await _firestore
        .collection(FirebaseStrings.driverColl)
        .doc(driverUid)
        .get();
        
  }
}
