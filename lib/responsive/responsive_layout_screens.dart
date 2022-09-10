import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
import '../utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getUserDate();
  }

  void getUserDate() async {
    setState(() {
      loading = true;
    });
    UserController userController = Get.find<UserController>();
    await userController.getUserInfoFromFirebase().then((value) {
        if (userController.userModel.uid.isNotEmpty) {
      setState(() {
        loading = false;
      });
    }
    });
  
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (constraints.maxWidth > Dimensions.webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}
