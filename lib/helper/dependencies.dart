
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/data/repository/firestore_repo.dart';
import 'package:instagram_clone/data/repository/storage_repo.dart';

import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/user_repo.dart';


Future<void> init() async {


  // repository
   Get.lazyPut(() => AuthRepo());
   Get.lazyPut(() => StorageRepo());
   Get.lazyPut(() => UserRepo());
   Get.lazyPut(() => FirestoreRepo());


  // controller
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find(),userController: Get.find()));
  Get.lazyPut(() => FirestoreController(firestoreRepo: Get.find()));

}
