import 'package:instagram_clone/data/repository/user_repo.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({required this.userRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late UserModel _userModel;

  UserModel get userModel => _userModel;

  void setUserModel(UserModel user) {
    _userModel = user;
    update();
  }

  Future<void> getUserInfoFromFirebase() async {
    _isLoading = true;
    _userModel = await userRepo.getUserInfoFromFirebase();
    if (_userModel.uid.isNotEmpty) {
      _isLoading = false;
      setUserModel(_userModel);
    }
  }
}
