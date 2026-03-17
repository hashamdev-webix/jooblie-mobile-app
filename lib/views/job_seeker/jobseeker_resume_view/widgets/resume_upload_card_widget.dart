import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/sized.dart';
import '../../../../viewmodels/jobseeker_resume_viewmodel.dart';
import '../../../../widgets/primary_button.dart';

class ResumeUploadCardWidget extends StatelessWidget {
  const ResumeUploadCardWidget({
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
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkMuted
                  : AppColors.lightMuted,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              Bootstrap.upload,
              size: 28,
              color: AppColors.primaryColor,
              // color: isDark
              //     ? AppColors.darkPrimary
              //     : AppColors.lightMutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload Resume',
            style: theme.textTheme.titleLarge!.copyWith(
                fontSize: 15
            ),
          ),
          6.h,
          Text(
            'PDF, DOC, or DOCX (max 5MB)',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 20),
          PrimaryButton(text: "Choose File", onPressed:vm.pickAndUpload,
            isLoading: vm.isUploading,
          ),

        ],
      ),
    );
  }
}
