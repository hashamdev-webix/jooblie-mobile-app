import 'package:flutter/material.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/profile_avtar_and_name_header_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/profile_field_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/profile_form_card_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/skill_chip_widget.dart';
import 'package:jooblie_app/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../viewmodels/jobseeker_profile_viewmodel.dart';

class JobseekerProfileView extends StatelessWidget {
  const JobseekerProfileView();

  @override
  Widget build(BuildContext context) {
    final jobSeekerViewModel = context.watch<JobseekerProfileViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkGradientBackground
            : AppColors.lightGradientBackground,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar + name header ──
              ProfileAvtarAndNameHeader(
                viewModel: jobSeekerViewModel,
                theme: theme,
              ),
              const SizedBox(height: 28),

              // ── Form Card ──
              ProfileFormCardWidget(
                theme: theme,
                isDark: isDark,
                jobSeekerProfileViewModel: jobSeekerViewModel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
