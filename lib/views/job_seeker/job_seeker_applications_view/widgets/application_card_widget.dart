import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/jobseeker_home_viewmodel.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/utils/my_slide_animation.dart';
import '../../../../models/job_application_model.dart';
import '../../job_seeker_recommendation_view/widgets/job_details_bottom_sheet.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplicationModel application;
  final ThemeData theme;
  final bool isDark;

  const ApplicationCard({
    required this.application,
    required this.theme,
    required this.isDark,
  });

  Color _statusColor(String status) {
    if (status.contains('Interview')) return Colors.green;
    if (status.contains('Review')) return Colors.orange;
    return AppColors.lightPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(application.status);
    return GestureDetector(
      onTap: () {
        if (application.jobData != null) {
          JobDetailsBottomSheet.show(context, application.jobData!);
        }
      },
      child: Container(
        // margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon row
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.work_outline,
                color: AppColors.lightPrimary,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              application.title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(application.company, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.lightMutedForeground,
                ),
                const SizedBox(width: 3),
                Text(
                  application.location,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.lightMutedForeground,
                ),
                const SizedBox(width: 3),
                Text(
                  application.date,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                application.status,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
