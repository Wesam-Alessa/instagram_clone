import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
import 'package:instagram_clone/screens/home/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/home/screens/home_screen.dart';
import 'package:instagram_clone/screens/home/screens/profile_screen.dart';
import 'package:instagram_clone/screens/home/screens/search_screen.dart';

List<Widget> homeScreenItems = [
          const HomeScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const Center(child: Text("4")),
          ProfileScreen(uid: Get.find<UserController>().userModel.uid,),
];
