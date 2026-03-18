import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/my_slide_animation.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_recommendation_view/widgets/recommendation_card_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/jobseeker_recommendations_viewmodel.dart';
import '../../../widgets/header_appbar_widget.dart';

class JobseekerRecommendationsView extends StatelessWidget {
  const JobseekerRecommendationsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobseekerRecommendationsViewModel>();
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
                padding: AppPadding.dashBoardPadding,

                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingTextWidget(
                          theme: theme,
                          title: 'AI Recommendations ✨',
                        ),

                        const SizedBox(height: 4),
                        SubTitleWidget(
                          theme: theme,
                          subTitle:
                              'Jobs matched to your profile and preferences.',
                        ),
                      ],
                    ),
                  ),

                  20.h,
                  ...vm.recommendations.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final app = entry.value;
                    return Column(
                      children: [
                        MySlideTransition(
                          delay: 100 * (idx + 1),
                          duration: 500,
                          child: RecommendationCard(
                            job: vm.recommendations[idx],
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
