import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/models/response_model.dart';
import 'package:instagram_clone/models/signup_body_model.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screens.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/auth/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    AuthController controller = Get.find<AuthController>();

    setState(() {
      _isLoading = true;
    });
    ResponseModel res = await controller.signInWithFirebase(
      SignUpBody(
        password: _passwordController.text,
        email: _emailController.text,
        bio: '',
        name: '',
        image: null,
      ),
    );

    if (!res.isSuccess) {
      // ignore: use_build_context_synchronously
      showSnackbar(res.message, context);
      setState(() {
        _isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > Dimensions.webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              SvgPicture.asset(
                "assets/images/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              SizedBox(height: Dimensions.height10 * 6.4),
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
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
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
                      : const Text("Log in"),
                ),
              ),
              SizedBox(height: Dimensions.height15 - 3),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.height15 / 2),
                    child: const Text("Dont have an account? "),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const SignupScreen())),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15 / 2),
                      child: const Text(
                        "Sign up.",
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
    );
  }
}
