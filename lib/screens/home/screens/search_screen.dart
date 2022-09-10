import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/firestore_controller.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fController = Get.find<FirestoreController>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: "Search for a user",
              labelStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (String val) {
              if (searchController.text.isNotEmpty) {
                setState(() {
                  showUsers = true;
                });
              } else {
                setState(() {
                  showUsers = false;
                });
              }
            },
          ),
        ),
        body: showUsers ? usersSearch(fController) : postsSearch(fController));
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> postsSearch(
      FirestoreController fController) {
    Future<QuerySnapshot<Map<String, dynamic>>>? list =
        searchController.text.isEmpty
            ? fController.getpostsSearch(searchController.text)
            : null;
    return list != null
        ? FutureBuilder(
            future: list,
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No Posts"));
              } else {
                return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    itemCount: snapshot.data!.docs.length,
                    staggeredTileBuilder: (index) => MediaQuery.of(context)
                                .size
                                .width >
                            Dimensions.webScreenSize
                        ? StaggeredTile.count(
                            (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                        : StaggeredTile.count(
                            (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                    itemBuilder: (context, index) {
                      PostModel post =
                          PostModel.fromMap(snapshot.data!.docs[index].data());
                      return Image.network(
                        post.postUrl,
                        fit: BoxFit.cover,
                      );
                    });
              }
            },
          )
        : FutureBuilder(builder: ((context, snapshot) => Container()));
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> usersSearch(
      FirestoreController fController) {
    return FutureBuilder(
      future: fController.getUserSearch(searchController.text),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            "Not Found",
            style: TextStyle(color: Colors.white),
          ));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              UserModel userModelSearch =
                  UserModel.fromMap(snapshot.data!.docs[index].data());
              return InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) =>
                        ProfileScreen(uid: userModelSearch.uid))),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: Dimensions.radius20,
                    backgroundImage: NetworkImage(userModelSearch.photoUrl),
                  ),
                  title: Text(
                    userModelSearch.name,
                    style: TextStyle(
                      fontSize: Dimensions.font18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
