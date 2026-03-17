import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_post_model.dart';
import 'package:jooblie_app/widgets/app_logo_widget.dart';

class DashboardApplicantTileWidget extends StatelessWidget {
  final RecentApplicant applicant;

  const DashboardApplicantTileWidget({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // color: theme.cardColor,
        color: isDark ? Color(0xff141D2C) : Color(0xffF5F9FC),
        borderRadius: BorderRadius.circular(14),
        // border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          AppLogo(
            width: 30,
            height: 30,
            borderRadius: 20,
            child: Center(
              child: Text(
                applicant.avatarInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.h,
                Text(
                  applicant.role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.lightMutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightSecondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lightSecondary.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              'Shortlist',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.lightSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
