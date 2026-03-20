import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_post_model.dart';
import 'package:jooblie_app/widgets/app_alert_dialog.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/recruiter_dashboard_viewmodel.dart';

class JobPostCard extends StatelessWidget {
  final JobPost job;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const JobPostCard(
      {super.key,
      required this.job,
      required this.onDelete,
      required this.onEdit});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF178F6F);
      case 'draft':
        return const Color(0xFFE0A020);
      case 'expired':
        return const Color(0xFFB04040);
      default:
        return const Color(0xFF178F6F);
    }
  }

  void _showStatusPicker(BuildContext context, bool isDark) {
    final vm = context.read<RecruiterJobsViewModel>();
    final statuses = ['active', 'draft', 'expired'];
    final statusLabels = {
      'active': 'Active',
      'draft': 'Draft',
      'expired': 'Expired',
    };
    final statusIcons = {
      'active': Icons.check_circle_outline,
      'draft': Icons.edit_outlined,
      'expired': Icons.cancel_outlined,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 0.8,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              16.h,
              Text(
                'Update Job Status',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              8.h,
              Text(
                'Change the status of "${job.title}"',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.lightMutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              20.h,
              ...statuses.map((s) {
                final isSelected = job.status == s;
                final color = _statusColor(s);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    if (!isSelected) vm.updateJobStatus(job.id, s);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.10)
                          : (isDark ? AppColors.darkMuted : AppColors.lightMuted),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? color.withValues(alpha: 0.5)
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: isSelected ? 1.5 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcons[s], color: color, size: 20),
                        12.w,
                        Text(
                          statusLabels[s]!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? color
                                : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check, color: color, size: 18),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
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
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight
        ],
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
            child:
                Icon(Icons.work_outline, color: AppColors.lightPrimary, size: 22),
          ),
          16.h,
          Text(job.title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          4.h,
          Text(
            'Posted ${job.postedDate.year}-${job.postedDate.month.toString().padLeft(2, '0')}-${job.postedDate.day.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkMutedForeground
                    : AppColors.lightMutedForeground),
          ),
          14.h,
          Row(
            children: [
              Icon(Icons.people_outline,
                  size: 16,
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.lightMutedForeground),
              6.w,
              Text('${job.applicants}',
                  style: theme.textTheme.bodyMedium),
              20.w,
              Icon(Icons.remove_red_eye_outlined,
                  size: 16,
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.lightMutedForeground),
              6.w,
              Text('${job.views}', style: theme.textTheme.bodyMedium),
            ],
          ),
          14.h,
          Row(
            children: [
              // Status badge — tappable to change
              GestureDetector(
                onTap: () => _showStatusPicker(context, isDark),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        job.status.isNotEmpty
                            ? job.status[0].toUpperCase() +
                                job.status.substring(1)
                            : '',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor, fontWeight: FontWeight.w600),
                      ),
                      4.w,
                      Icon(Icons.expand_more, color: statusColor, size: 14),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Edit icon
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit_outlined,
                      size: 18,
                      color: isDark
                          ? AppColors.darkMutedForeground
                          : AppColors.lightMutedForeground),
                ),
              ),
              12.w,
              // Delete icon — shows confirm dialog
              GestureDetector(
                onTap: () {
                  AppAlertDialog.show(
                    context,
                    title: 'Delete Job Post',
                    message:
                        'Are you sure you want to delete "${job.title}"? This action cannot be undone.',
                    confirmText: 'Delete',
                    cancelText: 'Cancel',
                    icon: Icons.delete_outline,
                    confirmColor: const Color(0xFFB04040),
                    onConfirm: onDelete,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB04040).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.delete_outline,
                      size: 18, color: const Color(0xFFB04040)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
