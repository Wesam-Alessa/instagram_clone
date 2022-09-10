import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
import 'package:instagram_clone/models/post.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class BottomNavigationBarComments extends StatefulWidget {
  final PostModel postModel;
  const BottomNavigationBarComments({Key? key, required this.postModel})
      : super(key: key);

  @override
  State<BottomNavigationBarComments> createState() =>
      _BottomNavigationBarCommentsState();
}

class _BottomNavigationBarCommentsState
    extends State<BottomNavigationBarComments> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().userModel;
    final fController = Get.find<FirestoreController>();
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(
            left: Dimensions.width10, right: Dimensions.width10 / 2),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: Dimensions.radius20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                      hintText: "Comment as ${user.name}",
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                fController.postComment(
                  commentController.text,
                  widget.postModel.postId,
                  user.uid,
                  widget.postModel.commentNumber,
                  context,
                );
                setState(() {
                  commentController.clear();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.send_rounded,
                  color: blueColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
