// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/data/repository/storage_repo.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/response_model.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ResponseModel> uploadPost(String description, Uint8List file,
      String uid, String porfImage, String name) async {
    ResponseModel res = ResponseModel(false, "some error occurred");
    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageRepo().uploadeImageToStorage("posts", file, true);
      PostModel post = PostModel(
          uid: uid,
          name: name,
          profImage: porfImage,
          description: description,
          postId: postId,
          datePublished: DateTime.now().toString(),
          postUrl: photoUrl,
          likes: [],
          commentNumber: 0
          //comments: [],
          );
      await _firestore.collection("posts").doc(postId).set(post.toMap());
      res = ResponseModel(true, "success");
    } catch (e) {
      res = ResponseModel(false, e.toString());
    }
    return res;
  }

  Future<void> likePost(
      String postId, String uid, List likes, BuildContext context) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      showSnackbar("error", context);
    }
  }

  Future<void> postComment(
    String commentText,
    String postId,
    String uid,
    int commentNumber,
    BuildContext context,
  ) async {
    try {
      if (commentText.isNotEmpty) {
        String commentID = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .set(
              CommentModel(
                commentId: commentID,
                uid: uid,
                commentText: commentText,
                datePublished: DateTime.now().toString(),
                likes: [],
              ).toMap(),
            );
        await _firestore
            .collection('posts')
            .doc(postId)
            .update({'comment_number': commentNumber + 1});
      } else {
        showSnackbar("Text is Empty", context);
      }
    } catch (e) {
      showSnackbar("error", context);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String postID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = const Stream.empty();
    try {
      stream = FirebaseFirestore.instance
          .collection("posts")
          .doc(postID)
          .collection('comments')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return stream;
  }

  Future<UserModel> getAnyUser(String uid, BuildContext context) async {
    UserModel user = UserModel(
        uid: "",
        name: "",
        photoUrl: "",
        email: "",
        bio: "",
        followers: [],
        following: []);
    try {
      if (uid.isNotEmpty) {
        await _firestore.collection('users').doc(uid).get().then((value) {
          user = UserModel.fromMap(value.data()!);
        });
      } else {
        showSnackbar("User ID is Empty", context);
      }
    } catch (e) {
      showSnackbar("error when fetch this comment", context);
    }
    return user;
  }

  Future<void> likeComment(String postId, String uid, List likes,
      String commentID, BuildContext context) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      showSnackbar("error", context);
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserSearch(String name) {
    late Future<QuerySnapshot<Map<String, dynamic>>> future;
    try {
      future = FirebaseFirestore.instance
          .collection("users")
          .where('name', isGreaterThanOrEqualTo: name)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return future;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsSearch(String uid) {
    late Future<QuerySnapshot<Map<String, dynamic>>> future;
    try {
      future = FirebaseFirestore.instance
          .collection("posts")
          .where('uid', isGreaterThanOrEqualTo: uid)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return future;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = const Stream.empty();
    try {
      stream = FirebaseFirestore.instance.collection("posts").snapshots();
    } catch (e) {
      print(e.toString());
    }
    return stream;
  }

  Future<int> getUserPostsLength(uid) async {
    int len = 0;
    try {
      var posts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();
      len = posts.docs.length;
      return len;
    } catch (e) {
      print(e.toString());
      return len;
    }
  }

  Future<void> followUser(
      String uid, String followID, BuildContext context) async {
    try {
      UserModel user = await getAnyUser(uid, context);
      if (user.following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID])
        });
      } else {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID])
        });
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }
}
