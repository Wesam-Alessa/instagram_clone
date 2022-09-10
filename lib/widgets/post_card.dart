import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/routes/route_helper.dart';
import 'package:instagram_clone/screens/home/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';

import '../controllers/firestore_controller.dart';

class PostCard extends StatefulWidget {
  final PostModel postModel;
  const PostCard({Key? key, required this.postModel}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().userModel;
    final fController = Get.find<FirestoreController>();
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > Dimensions.webScreenSize
              ? secondaryColor
              : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: Dimensions.radius20,
                  backgroundImage: NetworkImage(widget.postModel.profImage),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Dimensions.width10),
                    child: InkWell(
                      onTap: () => Get.toNamed(
                          RouteHelper.getProfile(widget.postModel.uid)),
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (builder) =>
                      //         ProfileScreen(uid: widget.postModel.uid))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.postModel.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.font18),
                          ),
                          Text(
                            DateFormat('E,d MMM yyyy HH:mm a').format(
                                DateTime.parse(widget.postModel.datePublished)),
                            style: TextStyle(
                              fontSize: Dimensions.font12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shrinkWrap: true,
                          children: ['Delete', "Hide post"].map(
                            (e) {
                              switch (e) {
                                case "Delete":
                                  return widget.postModel.uid == user.uid
                                      ? InkWell(
                                          onTap: () {
                                            fController.deletePost(
                                                widget.postModel.postId);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Text(e),
                                          ),
                                        )
                                      : Container();
                                case "Hide post":
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Text(e),
                                    ),
                                  );
                                default:
                                  return Container();
                              }
                            },
                          ).toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await fController.likePost(widget.postModel.postId, user.uid,
                  widget.postModel.likes, context);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  height: Dimensions.screenHeight * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.postModel.postUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAmination(
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    isAnimating: isLikeAnimating,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: Dimensions.iconSize16 * 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAmination(
                isAnimating: widget.postModel.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await fController.likePost(widget.postModel.postId,
                        user.uid, widget.postModel.likes, context);
                  },
                  icon: widget.postModel.likes.contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => CommentsScreen(
                            postModel: widget.postModel,
                          )));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.postModel.likes.length} likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.postModel.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " ${widget.postModel.description}",
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View ${widget.postModel.commentNumber} comments",
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
