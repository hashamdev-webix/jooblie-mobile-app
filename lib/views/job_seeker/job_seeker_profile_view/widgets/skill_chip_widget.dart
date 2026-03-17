import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/viewmodels/jobseeker_profile_viewmodel.dart';

class SkillChipWidget extends StatelessWidget {
  const SkillChipWidget({super.key, required this.viewModel});

  final JobseekerProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: viewModel.parsedSkills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightPrimary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            skill,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.lightPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
