import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/profile_field_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/skill_chip_widget.dart';

import '../../../../viewmodels/jobseeker_profile_viewmodel.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../core/utils/custom_easyloading.dart';
import '../../../../core/utils/custom_flushbar.dart';

class ProfileFormCardWidget extends StatelessWidget {
  const ProfileFormCardWidget({
    super.key,
    required this.theme,
    required this.isDark,
    required this.jobSeekerProfileViewModel,
  });

  final ThemeData theme;
  final bool isDark;
  final JobseekerProfileViewModel jobSeekerProfileViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          ProfileFieldWidget(
            label: 'Full Name',
            controller: jobSeekerProfileViewModel.nameController,
            icon: Icons.person_outline,
            theme: theme,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          ProfileFieldWidget(
            label: 'Email',
            controller: jobSeekerProfileViewModel.emailController,
            icon: Icons.mail_outline,
            theme: theme,
            isDark: isDark,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          ProfileFieldWidget(
            label: 'Location',
            controller: jobSeekerProfileViewModel.locationController,
            icon: Icons.location_on_outlined,
            theme: theme,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          ProfileFieldWidget(
            label: 'Job Title',
            controller: jobSeekerProfileViewModel.jobTitleController,
            icon: Icons.work_outline,
            theme: theme,
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // Bio (multiline)
          Text(
            'About',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: jobSeekerProfileViewModel.aboutController,
            maxLines: 3,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.lightPrimary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Skills
          Text(
            'Skills',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          // 2.h,
          ProfileFieldWidget(
            controller: jobSeekerProfileViewModel.skillsController,
            theme: theme,
            isDark: isDark,
            hintText: 'e.g. Flutter, Python, Design',
            showIcon: false,
          ),

          const SizedBox(height: 12),

          // Skill chips (auto-parsed)
          if (jobSeekerProfileViewModel.parsedSkills.isNotEmpty)
            SkillChipWidget(viewModel: jobSeekerProfileViewModel),
          const SizedBox(height: 24),

          // Save Button
          PrimaryButton(
            text: 'Save Changes',
            icon: Icons.save_outlined,

            onPressed: () async {
              CustomEasyLoading.show(context, message: 'Saving Profile...');
              final success = await jobSeekerProfileViewModel.saveChanges();
              CustomEasyLoading.dismiss();
              
              if (context.mounted && success) {
                CustomFlushbar.showSuccess(
                  context: context, 
                  message: 'Profile saved successfully!',
                );
              } else if (context.mounted) {
                CustomFlushbar.showError(
                  context: context, 
                  message: 'Failed to save profile. Please try again.',
                );
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
