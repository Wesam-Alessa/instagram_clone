import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart';

class UserRepo {
  Future<UserModel> getUserInfoFromFirebase() async {
    User user = FirebaseAuth.instance.currentUser!;
    late UserModel userModel;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data()!);
    });
    return userModel;
  }
}
