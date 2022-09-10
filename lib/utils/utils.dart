import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? xFile = await imagePicker.pickImage(source: source);
  if (xFile != null) {
    return await xFile.readAsBytes();
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
