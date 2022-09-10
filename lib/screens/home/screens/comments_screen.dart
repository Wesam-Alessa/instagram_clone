import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/bottom_navigation_bar_comment.dart';
import 'package:instagram_clone/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel postModel;
  const CommentsScreen({Key? key, required this.postModel}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<CommentModel> sortModels(snapshot) {
    List<CommentModel> list = [];
    snapshot.data!.docs.forEach((element) {
      CommentModel commentModel = CommentModel.fromMap(element.data());
      list.add(commentModel);
    });
    list.sort((a, b) => a.datePublished.compareTo(b.datePublished));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final fController = Get.find<FirestoreController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: fController.getComments(widget.postModel.postId),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No Comments",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (snapshot.hasData) {
              List<CommentModel> list = sortModels(snapshot);
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return CommentCard(
                    commentModel: list[index],
                    postId: widget.postModel.postId,
                  );
                },
              );
            }
            return Container();
          }),
      bottomNavigationBar: BottomNavigationBarComments(
        postModel: widget.postModel,
      ),
    );
  }
}
