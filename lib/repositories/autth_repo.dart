import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_finder/constants/firebase_strings.dart';
import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';

mixin AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  Future<UserCredential?> createUserWithEmailAndPass(
      {required String email, required String password}) async {
    UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return userCredential;
  }

  Future storeUserDatee(
      {required String uid, required Map<String, dynamic> data}) async {
    await _firestore.collection(FirebaseStrings.usersColl).doc(uid).set(data);
  }

  Future<DriverInfo?> getDriverData(String driverUid) async {
    DocumentSnapshot<Map<String, dynamic>> docsnap = await _firestore
        .collection(FirebaseStrings.driverColl)
        .doc(driverUid)
        .get();
    if (docsnap.exists) {
      DriverInfo driverInfo = DriverInfo.fromJson(docsnap.data() ?? {});
      return driverInfo;
    } else {
      return null;
    }
  }

  Future<UserModel?>  getUserDataa({required String uid}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection(FirebaseStrings.usersColl).doc(uid).get();
    if (documentSnapshot.exists) {
      UserModel userModel = UserModel.fromFirestore(documentSnapshot);

      return userModel;
    } else {
      return null;
    }
  }
}
