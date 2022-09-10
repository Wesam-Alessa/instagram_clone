// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/controllers/user_controller.dart';
 import 'package:instagram_clone/models/response_model.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _loading = false;

  _selectImages(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  postImage(String uid, String username, String profImage) async {
    final firestoreController = Get.find<FirestoreController>();
    setState(() {
      _loading = true;
    });
    try {
      ResponseModel res = await firestoreController.uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          profImage,
          username,
          context);
      if (res.isSuccess) {
        clear();
        showSnackbar("Posted", context);
      } else {
        clear();
        showSnackbar(res.message, context);
      }
    } catch (e) {
      clear();
      showSnackbar(e.toString(), context); 
      
    }
  }

  void clear() {
    setState(() {
      _loading = false;
      _descriptionController.clear();
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().userModel;
    return _file == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: () => _selectImages(context),
                ),
                // IconButton(
                //   icon: const Icon(Icons.logout),
                //   onPressed: () {
                //     FirebaseAuth.instance.signOut();
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => const LoginScreen(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: true,
              leading: IconButton(
                onPressed: clear,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: const Text("Post to"),
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.name, user.photoUrl),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                if (_loading) const LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.screenWidth * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.width15 * 3,
                      height: Dimensions.height45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                _file!,
                              ),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
