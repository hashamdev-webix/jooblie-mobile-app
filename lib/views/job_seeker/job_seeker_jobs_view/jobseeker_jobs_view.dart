import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_jobs_view/widgets/job_card_shimmer.dart';
import 'package:jooblie_app/widgets/custom_home_search_bar.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../viewmodels/job_seeker_jobs_viewmodel.dart';
import '../../../../core/sized.dart';
import '../../../../widgets/header_appbar_widget.dart';
import '../job_seeker_recommendation_view/widgets/job_details_bottom_sheet.dart';
import 'widgets/job_card_widget.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_jobs_view/widgets/job_filter_bottom_sheet.dart';


class JobSeekerJobsView extends StatefulWidget {
  const JobSeekerJobsView({super.key});

  @override
  State<JobSeekerJobsView> createState() => _JobSeekerJobsViewState();
}

class _JobSeekerJobsViewState extends State<JobSeekerJobsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobSeekerJobsViewModel>(context, listen: false).fetchJobs();
    });    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobSeekerJobsViewModel>();
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
                blackTitle: 'Browse ',
                blueTitle: 'Jobs',
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.fetchJobs(refresh: true),
                  color: AppColors.lightPrimary,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          !vm.isFetchingMore) {
                        vm.fetchJobs();
                      }
                      return false;
                    },
                    child: ListView(
                      padding: AppPadding.dashBoardPadding,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        // Search Header
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                CustomHomeSearchBar(
                                  searchHint: vm.filters.search ?? 'Search',
                                  locationHint: vm.filters.location ?? 'City, state, zip co...',
                                  onSearchTap: () => Navigator.pushNamed(context, RoutesName.search),
                                  onLocationTap: () => Navigator.pushNamed(context, RoutesName.locationSearch),
                                ),
                                10.h,
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 48,
                                        child: OutlinedButton.icon(
                                          onPressed: () => JobFilterBottomSheet.show(context),
                                          icon: Icon(
                                            Icons.filter_list_rounded,
                                            size: 20,
                                            color: vm.filters.hasActiveFilters ? AppColors.lightPrimary : null,
                                          ),
                                          label: Text(
                                            'Filters${vm.filters.hasActiveFilters ? ' (Active)' : ''}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: vm.filters.hasActiveFilters ? AppColors.lightPrimary : null,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            side: BorderSide(
                                              color: vm.filters.hasActiveFilters
                                                  ? AppColors.lightPrimary
                                                  : (isDark
                                                      ? AppColors.darkBorder
                                                      : AppColors.lightBorder),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (vm.filters.hasActiveFilters || vm.filters.search != null || vm.filters.location != null)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: IconButton(
                                          onPressed: () => vm.resetFilters(),
                                          icon: const Icon(Icons.refresh_rounded),
                                          tooltip: 'Clear All',
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        15.h,


                        // Loading State (Shimmer)
                        if (vm.isLoading)
                          ...List.generate(
                            3,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: JobCardShimmer(isDark: isDark),
                            ),
                          )
                        else if (vm.jobs.isEmpty)
                          _buildEmptyState(theme, isDark)
                        else ...[
                          ...vm.jobs.map((job) => FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: JobCardWidget(
                                  job: job,
                                  onTap: () {
                                    JobDetailsBottomSheet.show(context, job);
                                  },
                                ),
                              )),
                          if (vm.isFetchingMore)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.lightPrimary,
                                ),
                              ),
                            ),
                        ],
                        // Bottom padding for navigation bar
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: AppColors.lightPrimary,
      //   child: const Icon(
      //     Icons.chat_bubble_outline_rounded,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return FadeIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 80,
                color: isDark ? Colors.white24 : Colors.black12,
              ),
              20.h,
              Text(
                'No jobs found',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.h,
              Text(
                'Try adjusting your filters or search.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

