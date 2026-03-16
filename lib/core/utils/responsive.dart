import 'package:flutter/material.dart';

class Responsive {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  // Percentage of screen width
  static double w(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Percentage of screen height
  static double h(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Direct pixels adjusted slightly if desired (here they act as a base scale getter)
  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  static bool get isDesktop => screenWidth >= 1200;
}
