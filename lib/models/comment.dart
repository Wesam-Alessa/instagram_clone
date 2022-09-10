// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final String commentId;
  final String uid;
  final String commentText;
  final String datePublished;
  final List<dynamic> likes;
  CommentModel(
      {required this.commentId,
      required this.uid,
      required this.commentText,
      required this.datePublished,
      required this.likes,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'uid': uid,
      'commentText': commentText,
      'datePublished': datePublished,
      'likes': likes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
        commentId: map['commentId'] as String,
        uid: map['uid'] as String,
        commentText: map['commentText'] as String,
        datePublished: map['datePublished'] as String,
        likes: map['likes'],
);
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
