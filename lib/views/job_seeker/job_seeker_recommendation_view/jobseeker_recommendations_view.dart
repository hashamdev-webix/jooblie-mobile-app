import 'package:flutter/material.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_recommendation_view/widgets/recommendation_card_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../viewmodels/jobseeker_recommendations_viewmodel.dart';

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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
                      subTitle: 'Jobs matched to your profile and preferences.',
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => RecommendationCard(
                    job: vm.recommendations[i],
                    theme: theme,
                    isDark: isDark,
                  ),
                  childCount: vm.recommendations.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
