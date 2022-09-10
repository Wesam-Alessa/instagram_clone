import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final CommentModel commentModel;
  final String postId;
  const CommentCard(
      {Key? key, required this.commentModel, required this.postId})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final userModel = Get.find<UserController>().userModel;
  late UserModel commentUserModel;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUserComment(widget.commentModel.uid);
  }

  void getUserComment(String uid) async {
    setState(() {
      loading = true;
    });
    await Get.find<FirestoreController>()
        .getAnyUser(uid, context)
        .then((value) {
      commentUserModel = value;
      setState(() {
        loading = false;
      });
    });
  }

  void likeComment() async {
    await Get.find<FirestoreController>().likeComment(
        widget.postId,
        userModel.uid,
        widget.commentModel.likes,
        widget.commentModel.commentId,
        context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.height15, horizontal: Dimensions.width10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(commentUserModel.photoUrl),
                  radius: Dimensions.radius20,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Dimensions.width10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${commentUserModel.name} ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: widget.commentModel.commentText,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('E,d MMM yyyy HH:mm a').format(
                                DateTime.parse(
                                    widget.commentModel.datePublished)),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: Dimensions.font12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: likeComment,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: widget.commentModel.likes.contains(userModel.uid)
                        ? Icon(
                            Icons.favorite,
                            size: Dimensions.iconSize18,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            size: Dimensions.iconSize18,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          );
  }
}
