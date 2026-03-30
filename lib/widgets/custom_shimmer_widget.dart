import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_colors.dart';

class CustomShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final bool isDark;

  const CustomShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    required this.isDark,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const CustomShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    required this.isDark,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkBorder : Colors.grey[300]!,
      highlightColor: isDark ? AppColors.darkMuted : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkBorder : Colors.grey[300]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
