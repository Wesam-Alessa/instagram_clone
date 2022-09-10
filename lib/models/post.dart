import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostModel {
  final String uid;
  final String name;
  final String profImage;
  final String description;
  final String postId;
  final String datePublished;
  final String postUrl;
  final List likes; 
  final int commentNumber;

 
  PostModel({
    required this.uid,
    required this.name,
    required this.profImage,
    required this.description,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.commentNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profImage': profImage,
      'description': description,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'likes': likes,
      'comment_number': commentNumber,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profImage: map['profImage'] as String,
      description: map['description'] as String,
      postId: map['postId'] as String,
      datePublished: map['datePublished'] as String,
      postUrl: map['postUrl'] as String,
      likes: List.from((map['likes'] as List)),
      commentNumber: map['comment_number']
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
