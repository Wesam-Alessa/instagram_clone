// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/signup_body_model.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/data/repository/storage_repo.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required SignUpBody signUpBody
  }) async {
    String res = "some error occurred";
    try {
      if (signUpBody.email.isNotEmpty ||
          signUpBody.password.isNotEmpty ||
          signUpBody.bio.isNotEmpty ||
          signUpBody.name.isNotEmpty ||
          signUpBody.image != null) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: signUpBody.email, password: signUpBody.password);

        String photoUrl = await StorageRepo()
            .uploadeImageToStorage("profilePics", signUpBody.image!, false);

        model.UserModel user = model.UserModel(
            uid: credential.user!.uid,
            name: signUpBody.name,
            email: signUpBody.email,
            bio: signUpBody.bio,
            photoUrl: photoUrl,
            followers: [],
            following: []);

        await _firestore
            .collection("users")
            .doc(credential.user!.uid)
            .set(user.toMap());

        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signIn({
    required SignUpBody signUpBody
  }) async {
    String res = "some error occurred";
    try {
      if (signUpBody.email.isNotEmpty || signUpBody.password.isNotEmpty) {
        // ignore: unused_local_variable
        UserCredential credential = await _auth.signInWithEmailAndPassword(
            email: signUpBody.email, password: signUpBody.password);
        res = 'success';
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
