import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/my_slide_animation.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/profile_avtar_and_name_header_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/widgets/profile_form_card_widget.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/custom_shimmer_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/routes_name.dart';
import '../../../core/app_colors.dart';
import '../../../viewmodels/jobseeker_profile_viewmodel.dart';

class JobseekerProfileView extends StatelessWidget {
  const JobseekerProfileView();

  @override
  Widget build(BuildContext context) {
    final jobSeekerViewModel = context.watch<JobseekerProfileViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarWidget(
        title: "",
        showAppLogo: false,
      ),
      body: Container(
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
                jobSeekerViewModel.isLoading
                    ? _buildShimmerHeader(isDark)
                    : ProfileAvtarAndNameHeader(
                        viewModel: jobSeekerViewModel,
                        theme: theme,
                      ),
                const SizedBox(height: 28),

                // ── Form Card ──
                MySlideTransition(
                  child: jobSeekerViewModel.isLoading
                      ? _buildShimmerFormCard(theme, isDark)
                      : ProfileFormCardWidget(
                          theme: theme,
                          isDark: isDark,
                          jobSeekerProfileViewModel: jobSeekerViewModel,
                        ),
                ),
                const SizedBox(height: 24),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerHeader(bool isDark) {
    return Center(
      child: Column(
        children: [
           CustomShimmerWidget.circular(width: 100, height: 100, isDark: isDark),
          const SizedBox(height: 16),
           CustomShimmerWidget.rectangular(height: 28, width: 160,isDark: isDark),
          const SizedBox(height: 8),
           CustomShimmerWidget.rectangular(height: 16, width: 100,isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildShimmerFormCard(ThemeData theme, bool isDark) {
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
          for (int i = 0; i < 4; i++) ...[
             CustomShimmerWidget.rectangular(height: 16, width: 80,isDark:isDark),
            const SizedBox(height: 8),
             CustomShimmerWidget.rectangular(height: 50, width: double.infinity,isDark:isDark),
            const SizedBox(height: 16),
          ],
           CustomShimmerWidget.rectangular(height: 16, width: 80,isDark:isDark),
          const SizedBox(height: 8),
           CustomShimmerWidget.rectangular(height: 100, width: double.infinity,isDark:isDark),
          const SizedBox(height: 24),
           CustomShimmerWidget.rectangular(height: 54, width: double.infinity,isDark:isDark),
        ],
      ),
    );
  }
}
