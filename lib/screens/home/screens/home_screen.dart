import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/screens/auth/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width > Dimensions.webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: width > Dimensions.webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                "assets/images/ic_instagram.svg",
                color: primaryColor,
                height: Dimensions.height30,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (builder) => const LoginScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                    child: SvgPicture.asset(
                      "assets/images/messages.svg",
                      color: primaryColor,
                      height: Dimensions.height10 * 2.5,
                    ),
                  ),
                )
              ],
            ),
      body: StreamBuilder(
        stream: Get.find<FirestoreController>().getPosts(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              PostModel post =
                  PostModel.fromMap(snapshot.data!.docs[index].data());
              return Container(
                margin: EdgeInsets.symmetric(
                    horizontal:
                        width > Dimensions.webScreenSize ? width * 0.3 : 0,
                    vertical: width > Dimensions.webScreenSize ? 15 : 0),
                child: PostCard(
                  postModel: post,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
