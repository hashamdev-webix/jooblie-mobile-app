import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/utils/app_images.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final double borderRadius;

   AppLogo({
    super.key,
    this.width = 40,
    this.height = 40,
    // this.child = const Icon(Icons.work_outline, color: Colors.white, size: 30),
    this.child,
    this.borderRadius = 10,
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
      child:child ??  Image.asset(AppImages.appLogo,fit: BoxFit.cover,),
    );
  }
}
