import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/core/utils/my_slide_animation.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_applications_view/widgets/application_card_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_home_view/jobseeker_home_view.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../viewmodels/jobseeker_applications_viewmodel.dart';

class JobseekerApplicationsView extends StatelessWidget {
  const JobseekerApplicationsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobseekerApplicationsViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkGradientBackground
            : AppColors.lightGradientBackground,
      ),
      child: SafeArea(
        child: Column(
          children: [
            HeaderAppBarWidget(theme: theme, isDark: isDark),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingTextWidget(theme: theme, title: "My Applications"),
                        4.h,
                        SubTitleWidget(
                          theme: theme,
                          subTitle: "Track all your job applications in one place.",
                        ),
                      ],
                    ),
                  ),
                  20.h,
                  // ── Applications List ──
                  ...vm.applications.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final app = entry.value;
                    return Column(
                      children: [
                        MySlideTransition(
                          delay: 100 * (idx + 1),
                          duration: 500,
                          child: ApplicationCard(
                            application: app,
                            theme: theme,
                            isDark: isDark,
                          ),
                        ),
                        12.h,
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
