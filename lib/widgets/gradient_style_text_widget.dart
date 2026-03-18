import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class GradientStyleTextWidget extends StatelessWidget {
  final String title;
  final double fontSize;

  const GradientStyleTextWidget({
    super.key,
    required this.title,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return AppColors.gradientPrimary.createShader(bounds);
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // important
        ),
      ),
    );
  }
}
