import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String uid;
  final String name;
  final String photoUrl;
  final String email;
  final String bio;
  final List followers;
  final List following;
  UserModel({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'photoUrl': photoUrl,
      'email': email,
      'bio': bio,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
      followers: List.from((map['followers'] as List)),
      following: List.from((map['following'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
