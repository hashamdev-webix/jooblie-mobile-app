import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double borderRadius;
  const AppLogo({
    super.key,
    this.width=40,
    this.height=34,
    this.child=const Icon(
      Icons.work_outline,
      color: Colors.white,
      size: 20,
    ),
    this.borderRadius=8
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child:child,
    );
  }
}
