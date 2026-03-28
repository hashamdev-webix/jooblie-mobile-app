import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/my_slide_animation.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_applications_view/jobseeker_applications_view.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_home_view/widgets/job_seeker_home_tile_widget.dart';
import 'package:jooblie_app/widgets/custom_shimmer_widget.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../models/home_stats_model.dart';
import '../../../viewmodels/jobseeker_home_viewmodel.dart';
import '../../../core/utils/routes_name.dart';
import '../../recruiter/recruiter_dashboard_view/widgets/stat_card_widget.dart';
import '../../recruiter/recruiter_dashboard_view/widgets/card_width_list_tile.dart';

class JobseekerHomeView extends StatefulWidget {
  const JobseekerHomeView();

  @override
  State<JobseekerHomeView> createState() => _JobseekerHomeViewState();
}

class _JobseekerHomeViewState extends State<JobseekerHomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobseekerHomeViewModel>(context, listen: false).fetchStats();
    });
  }

  IconData _iconFor(String asset) {
    switch (asset) {
      case 'applications':
        return Icons.description_outlined;
      case 'interviews':
        return Icons.work_outline;
      case 'saved':
        return Icons.star_border_rounded;
      case 'views':
        return Icons.remove_red_eye_outlined;
      case 'jobs_views':
        return Icons.insights_outlined;
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
      case 'Offer':
        return Colors.blue;
      case 'Rejected':
        return Colors.red;
      default:
        return AppColors.lightPrimary;
    }
  }

  Widget _buildShimmerStats(bool isDark) {
    return Column(
      children: List.generate(
        4,
        (i) => Column(
          children: [
            CustomShimmerWidget.rectangular(
              height: 80,
              isDark: isDark,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            12.h,
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRecent(bool isDark) {
    return CustomShimmerWidget.rectangular(
      height: 220,
      isDark: isDark,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobseekerHomeViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.darkGradientBackground
                : AppColors.lightGradientBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderAppBarWidget(
                theme: theme,
                isDark: isDark,
                blackTitle: 'Job',
                blueTitle: 'lie',
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: vm.fetchStats,
                  color: AppColors.lightPrimary,
                  child: ListView(
                    padding: AppPadding.dashBoardPadding,
                    children: [
                      // ── Header ──
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeadingTextWidget(
                              theme: theme,
                              title: vm.isLoading
                                  ? 'Welcome back! 👋'
                                  : 'Welcome back${vm.userName.isNotEmpty ? ', ${vm.userName}' : ''}! 👋',
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

                      // ── Stats Cards ──
                      if (vm.isLoading)
                        _buildShimmerStats(isDark)
                      else if (vm.error != null)
                        _buildErrorWidget(vm, theme, isDark)
                      else
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
                                  onTap: () {
                                    if (stat.label == 'Saved Jobs') {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.favorites,
                                      );
                                    } else if (stat.label == 'Profile Views') {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.profileInsights,
                                      );
                                    }
                                    // else if (stat.label == 'Job Views') {
                                    //   vm.navigateToJobInsights(context);
                                    // }
                                    else if (stat.label == 'Interviews') {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.applicationScreen,
                                        arguments: {
                                          "filterStatus": "Interview",
                                          "showLeadingBackButton": true,
                                        },
                                      );

                                      // Navigator.pushNamed(
                                      //   context,
                                      //   RoutesName.applicationScreen,
                                      //
                                      //
                                      //   // arguments: {
                                      //   //   'isJobSeeker': true,
                                      //   //   'initialIndex': 3,
                                      //   // },
                                      // );
                                    } else if (stat.label == 'Applications') {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.applicationScreen,
                                        arguments: {
                                          "showLeadingBackButton": true,
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              12.h,
                            ],
                          );
                        }),

                      20.h,

                      // ── Recent Applications ──
                      if (vm.isLoading)
                        _buildShimmerRecent(isDark)
                      else if (!vm.isLoading && vm.error == null)
                        MySlideTransition(
                          child: CardWithListTile(
                            theme: theme,
                            isDark: isDark,
                            title: 'Recent Applications',
                            items: vm.recentApplications.isEmpty
                                ? [null]
                                : vm.recentApplications,
                            itemBuilder: (context, dynamic item, idx) {
                              if (item == null) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No applications yet.\nStart applying to jobs!',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: isDark
                                                ? AppColors.darkMuted
                                                : Colors.grey[500],
                                          ),
                                    ),
                                  ),
                                );
                              }
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    JobseekerHomeViewModel vm,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: isDark ? AppColors.darkMuted : Colors.grey,
          ),
          12.h,
          Text(
            'Could not load stats.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkMuted : Colors.grey[600],
            ),
          ),
          12.h,
          ElevatedButton.icon(
            onPressed: vm.fetchStats,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
