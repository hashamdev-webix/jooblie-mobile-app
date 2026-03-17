import 'package:flutter/material.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_applications_view/widgets/application_card_widget.dart';
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => ApplicationCard(
                    application: vm.applications[i],
                    theme: theme,
                    isDark: isDark,
                  ),
                  childCount: vm.applications.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
