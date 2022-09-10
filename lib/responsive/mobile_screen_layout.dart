import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../utils/global_var.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationtapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: navigationtapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.add_circle_outline,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.favorite_outline,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.person_outline,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            backgroundColor: mobileBackgroundColor,
          ),
        ],
      ),
    );
  }
}
