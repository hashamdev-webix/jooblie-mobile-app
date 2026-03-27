import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';

class StatCardWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String change;
  final VoidCallback? onTap;

  const StatCardWidget({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.change,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight,
          ],
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: AppColors.lightPrimary.withValues(alpha: 0.85),
                  size: 22,
                ),
                Text(
                  change,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.lightSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            12.h,
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            4.h,
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkMutedForeground
                    : AppColors.lightMutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
