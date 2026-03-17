import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_post_model.dart';

class JobPostCard extends StatelessWidget {
  final JobPost job;
  final VoidCallback onDelete;

  const JobPostCard({super.key, required this.job, required this.onDelete});

  Color _statusColor(JobStatus status) {
    switch (status) {
      case JobStatus.active:  return const Color(0xFF178F6F);
      case JobStatus.paused:  return const Color(0xFFE0A020);
      case JobStatus.closed:  return const Color(0xFFB04040);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(job.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.work_outline, color: AppColors.lightPrimary, size: 22),
          ),
          16.h,
          Text(job.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          4.h,
          Text('Posted ${job.postedDate}', style: theme.textTheme.bodySmall?.copyWith(color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground)),
          14.h,
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground),
              6.w,
              Text('${job.applicants}', style: theme.textTheme.bodyMedium),
              20.w,
              Icon(Icons.remove_red_eye_outlined, size: 16, color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground),
              6.w,
              Text('${job.views}', style: theme.textTheme.bodyMedium),
            ],
          ),
          14.h,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              job.status.name[0].toUpperCase() + job.status.name.substring(1),
              style: theme.textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
            ),
          ),
          16.h,
          Row(
            children: [
              GestureDetector(onTap: () {}, child: Icon(Icons.edit_outlined, size: 20, color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground)),
              16.w,
              GestureDetector(onTap: onDelete, child: Icon(Icons.delete_outline, size: 20, color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground)),
            ],
          ),
        ],
      ),
    );
  }
}
