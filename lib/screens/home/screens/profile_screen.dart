import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/routes/route_helper.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel user;
  bool loading = false;
  int postLen = 0;
  bool isFollowing = false;
  bool itsMe = false;
  int followers = 0;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final userController = Get.find<UserController>();
    final fController = Get.find<FirestoreController>();
    setState(() {
      loading = true;
    });
    try {
      if (widget.uid == userController.userModel.uid) {
        user = userController.userModel;
        postLen = await fController.getUserPostsLength(user.uid);
        itsMe = true;
        followers = user.followers.length;
        setState(() {
          loading = false;
        });
      } else {
        user = await fController.getAnyUser(widget.uid, context);
        postLen = await fController.getUserPostsLength(user.uid);
        isFollowing = user.followers.contains(userController.userModel.uid);
        followers = user.followers.length;
        if (user.uid.isNotEmpty) {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fController = Get.find<FirestoreController>();
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : WillPopScope(
            onWillPop: () async {
              Get.offAllNamed(RouteHelper.getInitial());
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(user.name),
                centerTitle: false,
                automaticallyImplyLeading: false,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: Dimensions.radius20 * 2,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(user.photoUrl),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      buildStateColumn(postLen, "posts"),
                                      buildStateColumn(followers, "followers"),
                                      buildStateColumn(
                                          user.following.length, "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      itsMe
                                          ? FolowButton(
                                              text: "sign Out",
                                              textColor: primaryColor,
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              borderColor: Colors.grey,
                                              function: () {
                                                FirebaseAuth.instance.signOut();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (builder) =>
                                                                const LoginScreen()));
                                              },
                                            )
                                          : isFollowing
                                              ? FolowButton(
                                                  text: "Unfollow",
                                                  textColor: Colors.white,
                                                  backgroundColor: Colors.blue,
                                                  borderColor: Colors.blue,
                                                  function: () {
                                                    fController.followUser(
                                                        Get.find<
                                                                UserController>()
                                                            .userModel
                                                            .uid,
                                                        user.uid,
                                                        context);
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FolowButton(
                                                  text: "Follow",
                                                  textColor: Colors.white,
                                                  backgroundColor: Colors.blue,
                                                  borderColor: Colors.blue,
                                                  function: () {
                                                    fController.followUser(
                                                        Get.find<
                                                                UserController>()
                                                            .userModel
                                                            .uid,
                                                        user.uid,
                                                        context);
                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: Dimensions.height15),
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: Dimensions.font11 * 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            user.bio,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                    future: fController.getpostsSearch(user.uid),
                    builder: ((context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        List list = [];
                        for (var element in snapshot.data!.docs) {
                          if (element.data()['uid'] == user.uid) {
                            list.add(element.data());
                          }
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              PostModel post = PostModel.fromMap(list[index]);
                              return Image(
                                image: NetworkImage(post.postUrl),
                                fit: BoxFit.cover,
                              );
                            });
                      }
                      return const Center(
                        child: Text("No Posts"),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
