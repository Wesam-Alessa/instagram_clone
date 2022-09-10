import 'dart:typed_data';

class SignUpBody {
  String name;

  String password;

  String email;

  String bio;

  Uint8List? image;

  SignUpBody({
    required this.name,
    required this.password,
    required this.email,
    required this.bio,
    required this.image
  });

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = {};
    data['f_name'] = name;
    data['bio'] = bio;
    data['email'] = email;
    data['password'] = password;
    data['image'] = image;
    return data;
  }
}
