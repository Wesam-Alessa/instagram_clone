import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/user_controller.dart';

import '../data/repository/auth_repo.dart';
import '../models/response_model.dart';
import '../models/signup_body_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserController userController;
  AuthController({required this.authRepo,required this.userController});

  bool _isLoading = false;

  bool get isLoading => _isLoading;


  Future<ResponseModel> signInWithFirebase(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    String respond = await authRepo.signIn(signUpBody: signUpBody);
    late ResponseModel responseModel;
    if (respond == 'success') {
      await userController.getUserInfoFromFirebase();
      final tokenResult = FirebaseAuth.instance.currentUser!;
      final idToken = await tokenResult.getIdToken();
      final token = idToken;
      //authRepo.saveUserToken(token);
      responseModel = ResponseModel(true, token);
    } else {
      responseModel = ResponseModel(false, "Error when signIn account");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registrationWithFirebase(SignUpBody signUpBody) async {
     late ResponseModel responseModel;
    _isLoading = true;
    update();
    String respons = await authRepo.signUpUser(signUpBody:signUpBody);
    if (respons == 'success') {
      await userController.getUserInfoFromFirebase();
      final tokenResult = FirebaseAuth.instance.currentUser!;
      final idToken = await tokenResult.getIdToken();
      final token = idToken;
      //authRepo.saveUserToken(token);
      responseModel = ResponseModel(
          true, token);
    } else {
      responseModel = ResponseModel(false, 
       "Error when registration account"
       );
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  

  // void saveUserNumberAndPassword(String password, String number) async {
  //   authRepo.saveUserNumberAndPassword(password, number);
  // }

  // bool userLoggedIn() {
  //   return authRepo.userLoggedIn();
  // }

  // bool clearSharedData() {
  //   return authRepo.clearSharedData();
  // }

}
