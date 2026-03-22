import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/viewmodels/jobseeker_resume_viewmodel.dart';

class CurrentResumeCardWidget extends StatelessWidget {
  const CurrentResumeCardWidget({
    super.key,
    required this.theme,
    required this.isDark,
    required this.vm,
  });

  final ThemeData theme;
  final bool isDark;
  final JobseekerResumeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
          isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          isDark
              ? AppColors.shadowCardDark
              : AppColors.shadowCardLight,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Resume',
              style: theme.textTheme.titleLarge!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              )),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // color: theme.cardColor,
              color: isDark ? Color(0xff141D2C) : Color(0xffF5F9FC),
              borderRadius: BorderRadius.circular(14),
              // border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.insert_drive_file_outlined,
                      color: AppColors.lightPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.currentResume!.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Uploaded ${vm.currentResume!.uploadDate} • ${vm.currentResume!.fileSize}',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                vm.isDownloading
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          value: vm.downloadProgress,
                          strokeWidth: 2.5,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          color: AppColors.lightPrimary,
                        ),
                      )
                    : IconButton(
                        icon: Icon(Bootstrap.cloud_download,
                            size: 20,
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.lightMutedForeground),
                        onPressed: vm.downloadResume,
                      ),
                IconButton(
                  icon: Icon(Bootstrap.trash,
                      size: 20,
                      color: isDark
                          ? AppColors.darkMutedForeground
                          : AppColors.lightMutedForeground),
                  onPressed: vm.deleteResume,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // AI Analysis chip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightSecondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightSecondary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✨ ',
                    style: TextStyle(
                        color: AppColors.lightSecondary,
                        fontSize: 14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.lightSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vm.currentResume!.aiMessage,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
