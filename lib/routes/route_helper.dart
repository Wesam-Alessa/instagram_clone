
import 'package:get/get.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/home/screens/home_screen.dart';
import 'package:instagram_clone/screens/home/screens/initial_screen.dart';
import 'package:instagram_clone/screens/home/screens/profile_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String home = '/home';
  static const String web = '/web';
  static const String mobile = '/mobile';
  static const String profile = '/profile';

  static String getInitial() => initial;
  static String getHome() => home;
  static String getWeb() => web;
  static String getMobile() => mobile;
  static String getProfile(String uid) => "$profile?uid=$uid";


  static List<GetPage> routes = [
    GetPage(
        name: initial,
        page: () =>const InitialScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
        name: home,
        page: () => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
        name: web,
        page: () => const WebScreenLayout(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
        name: mobile,
        page: () => const MobileScreenLayout(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),  
    GetPage(
        name: profile,
        page: () {
          String uid = Get.parameters['uid']!;
          return ProfileScreen(uid:uid );
        },
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),           
  ];
}
