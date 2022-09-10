import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/repository/firestore_repo.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../models/response_model.dart';

class FirestoreController extends GetxController implements GetxService {
  final FirestoreRepo firestoreRepo;
  FirestoreController({required this.firestoreRepo});

  Future<ResponseModel> uploadPost(String description, Uint8List file,
      String uid, String porfImage, String name, BuildContext context) async {
    ResponseModel res = ResponseModel(false, "some error occurred");
    try {
      res = await firestoreRepo.uploadPost(
          description, file, uid, porfImage, name);
      if (res.isSuccess) {
        return res;
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    return res;
  }

  Future<void> likePost(
      String postId, String uid, List likes, BuildContext context) async {
    await firestoreRepo.likePost(postId, uid, likes, context);
  }

  Future<void> postComment(String commentText, String postId, String uid,
      int commentNumber, BuildContext context) async {
    await firestoreRepo.postComment(
        commentText, postId, uid, commentNumber, context);
  }

  Future<void> likeComment(String postId, String uid, List likes,
      String commentID, BuildContext context) async {
    await firestoreRepo.likeComment(postId, uid, likes, commentID, context);
  }

  Future<UserModel> getAnyUser(String uid, BuildContext context) async {
    return await firestoreRepo.getAnyUser(uid, context);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String postID) {
    return firestoreRepo.getComments(postID);
  }

  Future<void> deletePost(
    String postID,
  ) async {
    await firestoreRepo.deletePost(postID);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserSearch(String name) async {
    return await firestoreRepo.getUserSearch(name);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getpostsSearch(String uid) async {
    return await firestoreRepo.getPostsSearch(uid);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return firestoreRepo.getPosts();
  }

  Future<int> getUserPostsLength(String uid) async {
    return await firestoreRepo.getUserPostsLength(uid);
  }

  Future<void> followUser(
      String uid, String followID, BuildContext context) async {
    await firestoreRepo.followUser(uid, followID, context);
  }
}
