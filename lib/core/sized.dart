import 'package:flutter/material.dart';
import 'utils/responsive.dart';

class Sized {
  // Returns a SizedBox with fixed height
  static Widget h(double height) => SizedBox(height: height);
  // Returns a SizedBox with fixed width
  static Widget w(double width) => SizedBox(width: width);

  // Returns a responsive height SizedBox based on screen percentage
  static Widget resH(double percentage) => SizedBox(height: Responsive.h(percentage));
  // Returns a responsive width SizedBox based on screen percentage
  static Widget resW(double percentage) => SizedBox(width: Responsive.w(percentage));
}

// Extension to allow usage like 20.h or 15.w for fixed sizes, 
// and 5.resH / 10.resW for responsive percentages
extension SizedExtension on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get resH => SizedBox(height: Responsive.h(toDouble()));
  SizedBox get resW => SizedBox(width: Responsive.w(toDouble()));
}
