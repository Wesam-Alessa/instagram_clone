import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/controllers/auth_controller.dart';
import 'package:instagram_clone/models/response_model.dart';
import 'package:instagram_clone/models/signup_body_model.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screens.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/auth/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _nameController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signupUser() async {
    AuthController controller = Get.find<AuthController>();
    
    setState(() {
      _isLoading = true;
    });
    
    ResponseModel res = await controller.registrationWithFirebase(SignUpBody(
      name: _nameController.text,
      password: _passwordController.text,
      email: _emailController.text,
      bio: _bioController.text,
      image: _image,
    ));
    setState(() {
      _isLoading = false;
    });
    if (!res.isSuccess) {
      // ignore: use_build_context_synchronously
      showSnackbar(res.message, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:  MediaQuery.of(context).size.width > Dimensions.webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.height10 * 2.4),
                SvgPicture.asset(
                  "assets/images/ic_instagram.svg",
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(height: Dimensions.height10 * 6.4),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: Dimensions.radius10 * 6.4,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: Dimensions.radius10 * 6.4,
                            backgroundImage: const NetworkImage(
                              "https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg",
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height10 * 2.4),
                TextFieldInput(
                  controller: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: Dimensions.height10 * 2.4),
                TextFieldInput(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPassword: true,
                ),
                SizedBox(height: Dimensions.height10 * 2.4),
                TextFieldInput(
                  controller: _bioController,
                  hintText: "Enter your bio",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: Dimensions.height10 * 2.4),
                TextFieldInput(
                  controller: _nameController,
                  hintText: "Enter your name",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: Dimensions.height10 * 2.4),
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.height10),
                    decoration: ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              Dimensions.radius10 / 2,
                            ),
                          ),
                        )),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const Text("Sign up"),
                  ),
                ),
                SizedBox(height: Dimensions.height15 - 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15 / 2),
                      child: const Text("Already have an account? "),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen())),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height15 / 2),
                        child: const Text(
                          "Log in.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
