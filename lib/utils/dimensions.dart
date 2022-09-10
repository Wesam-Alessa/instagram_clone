
import 'package:flutter/material.dart';

MediaQueryData window =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window);

class Dimensions {
  static double screenHeight = window.size.height;
  static double screenWidth = window.size.width;

  static double webScreenSize = 600;
// dynamic height padding and margin
  static double height10 = screenHeight / (screenHeight / 10); //84.4
  static double height15 = screenHeight / (screenHeight / 15); //56.27
  static double height20 = screenHeight / (screenHeight / 20); //42.2
  static double height30 = screenHeight / (screenHeight / 30); //28.13
  static double height45 = screenHeight / (screenHeight / 45); //18.76

// dynamic width padding and margin
  static double width10 = screenHeight / (screenWidth / 10); //84.4
  static double width15 = screenHeight / (screenWidth / 15); //56.27
  static double width20 = screenHeight / (screenWidth / 20); //42.2
  static double width30 = screenHeight / (screenWidth / 30); //28.13

// dynamic font size
  static double font11 = screenHeight / (screenHeight / 11); 
  static double font12 = screenHeight / (screenHeight / 12); //52.75
  static double font14 = screenHeight / (screenHeight / 14); //52.75
  static double font16 = screenHeight / (screenHeight / 16); //52.75
  static double font18 = screenHeight / (screenHeight / 18);
  static double font20 = screenHeight / (screenHeight / 20); //42.2
  static double font26 = screenHeight / (screenHeight / 26); //32.46

// dynamic radius
  static double radius10 = screenHeight / (screenHeight / 10); //71
  static double radius15 = screenHeight / (screenHeight / 15); //56.27
  static double radius20 = screenHeight / (screenHeight / 20); //42.2
  static double radius25 = screenHeight / (screenHeight / 25); //35.165
  static double radius30 = screenHeight / (screenHeight / 30); //28.13

// dynamic icon size
  static double iconSize13 = screenHeight / (screenHeight / 13);
  static double iconSize16 = screenHeight / (screenHeight / 16); //52.75
  static double iconSize18 = screenHeight / (screenHeight / 18); 
  static double iconSize24 = screenHeight / (screenHeight / 24); //35.17

}