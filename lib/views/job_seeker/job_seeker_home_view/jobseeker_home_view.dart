import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/my_slide_animation.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_home_view/widgets/job_seeker_home_tile_widget.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../models/home_stats_model.dart';
import '../../../viewmodels/jobseeker_home_viewmodel.dart';
import 'package:jooblie_app/widgets/custom_home_search_bar.dart';
import '../../../core/utils/routes_name.dart';
import '../../recruiter/recruiter_dashboard_view/widgets/stat_card_widget.dart';
import '../../recruiter/recruiter_dashboard_view/widgets/card_width_list_tile.dart';

class JobseekerHomeView extends StatelessWidget {
  const JobseekerHomeView();

  static IconData _iconFor(String asset) {
    switch (asset) {
      case 'applications':
        return Icons.description_outlined;
      case 'interviews':
        return Icons.work_outline;
      case 'saved':
        return Icons.star_border_rounded;
      case 'views':
        return Icons.remove_red_eye_outlined;
      default:
        return Icons.bar_chart;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Interview':
        return Colors.green;
      case 'Under Review':
        return Colors.orange;
      default:
        return AppColors.lightPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobseekerHomeViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderAppBarWidget(theme: theme, isDark: isDark, blackTitle: 'Job', blueTitle: 'lie'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 100),
                  children: [
                    // ── Header ──
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingTextWidget(
                            theme: theme,
                            title: 'Welcome back, Jooblie! 👋',
                          ),
                          4.h,
                          SubTitleWidget(
                            subTitle: "Here's your job search overview.",
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                    20.h,
                
                    // FadeInUp(
                    //   duration: const Duration(milliseconds: 600),
                    //   child: CustomHomeSearchBar(
                    //     onSearchTap: () => Navigator.pushNamed(context, RoutesName.search),
                    //     onLocationTap: () => Navigator.pushNamed(context, RoutesName.search),
                    //   ),
                    // ),
                    // 20.h,
                
                    // ── Stats Cards ──
                    ...vm.stats.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final stat = entry.value;
                      return Column(
                        children: [
                          MySlideTransition(
                            delay: 100 * (idx + 1),
                            duration: 500,
                            child: StatCardWidget(
                              icon: _iconFor(stat.iconAsset),
                              value: '${stat.count}',
                              label: stat.label,
                              change: stat.badge,
                            ),
                          ),
                          12.h,
                        ],
                      );
                    }),
                
                    20.h,
                
                    // FadeInLeft
                    MySlideTransition(
                      // delay: const Duration(milliseconds: 500),
                      // duration: const Duration(milliseconds: 400),
                      child: CardWithListTile(
                        theme: theme,
                        isDark: isDark,
                        title: 'Recent Applications',
                        items: vm.recentApplications,
                        itemBuilder: (context, dynamic item, idx) {
                          final app = item as RecentApplicationModel;
                          final color = _statusColor(app.status);
                          return JobSeekerHomeApplicantTile(
                            isDark: isDark,
                            app: app,
                            theme: theme,
                            color: color,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

