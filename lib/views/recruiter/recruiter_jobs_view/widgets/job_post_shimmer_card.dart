import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/sized.dart';
import '../../../../widgets/custom_shimmer_widget.dart';

class JobPostShimmerCard extends StatelessWidget {
  const JobPostShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerWidget.rectangular(
                height: 20,
                width: 150,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              CustomShimmerWidget.rectangular(
                height: 24,
                width: 24,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          8.h,
          CustomShimmerWidget.rectangular(
            height: 14,
            width: 100,
            isDark: isDark,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          16.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerWidget.rectangular(
                height: 48,
                width: 70,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              CustomShimmerWidget.rectangular(
                height: 48,
                width: 70,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              CustomShimmerWidget.rectangular(
                height: 28,
                width: 60,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
