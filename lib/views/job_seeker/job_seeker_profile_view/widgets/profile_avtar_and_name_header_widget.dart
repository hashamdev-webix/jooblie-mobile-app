import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/jobseeker_profile_viewmodel.dart';

import '../../../../core/app_colors.dart';

class ProfileAvtarAndNameHeader extends StatelessWidget {
  const ProfileAvtarAndNameHeader({
    super.key,
    required this.viewModel,
    required this.theme,
  });

  final JobseekerProfileViewModel viewModel;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.gradientPrimary,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            viewModel.profile.fullName,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text('Job Seeker', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
