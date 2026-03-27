import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/views/recruiter/recruiter_jobs_view/widgets/jobs_card_widget.dart';
import 'package:jooblie_app/views/recruiter/recruiter_jobs_view/widgets/job_post_shimmer_card.dart';
import 'package:jooblie_app/views/recruiter/recruiter_post_job_view/recruiter_post_job_view.dart';
import 'package:jooblie_app/widgets/buttons/primary_button_with_icon.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/recruiter_dashboard_viewmodel.dart';

class RecruiterJobsView extends StatelessWidget {
  const RecruiterJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecruiterJobsViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            HeaderAppBarWidget(
              theme: theme,
              isDark: isDark,
              showSetting: false,
              showProfileIcon: true,
              showLeadingIcon: false,
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => vm.fetchJobs(refresh: true),
                color: AppColors.lightPrimary,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!vm.isLoading &&
                        !vm.isFetchingMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      vm.fetchJobs();
                      return true;
                    }
                    return false;
                  },
                  child: ListView(
                    padding: AppPadding.dashBoardPadding,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeadingTextWidget(
                                    theme: theme,
                                    title: 'My Job Posts',
                                  ),
                                  4.h,
                                  SubTitleWidget(
                                    theme: theme,
                                    subTitle:
                                        'Manage your active job listings.',
                                  ),
                                ],
                              ),
                            ),
                            FadeInRight(
                              delay: const Duration(milliseconds: 200),
                              duration: const Duration(milliseconds: 500),
                              child: PrimaryButtonWithIcon(
                                btnText: 'New job',
                                icon: Icons.add,
                                onTap: () {
                                  // Simply push a fresh view for new job or could redirect to tab
                                  context
                                      .read<RecruiterPostJobViewModel>()
                                      .formKey
                                      .currentState
                                      ?.reset();
                                  context
                                          .read<RecruiterPostJobViewModel>()
                                          .editingJobId =
                                      null;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RecruiterPostJobView(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.h,
                      _buildFilterChips(context, vm, isDark),
                      24.h,
                      if (vm.isLoading && vm.jobs.isEmpty)
                        ...List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: const JobPostShimmerCard(),
                          ),
                        )
                      else if (vm.jobs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.work_off_outlined,
                                  size: 60,
                                  color: isDark
                                      ? AppColors.darkMutedForeground
                                      : AppColors.lightMutedForeground,
                                ),
                                16.h,
                                Text(
                                  'No jobs found.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isDark
                                        ? AppColors.darkMutedForeground
                                        : AppColors.lightMutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        ...vm.jobs.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final job = entry.value;
                          return FadeInUp(
                            delay: Duration(
                              milliseconds: 150 + (idx % 5) * 120,
                            ),
                            duration: const Duration(milliseconds: 500),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: JobPostCard(
                                job: job,
                                onDelete: () => vm.deleteJob(job.id),
                                onEdit: () {
                                  context
                                      .read<RecruiterPostJobViewModel>()
                                      .loadJobForEditing(job);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RecruiterPostJobView(),
                                    ),
                                  ).then((_) {
                                    vm.fetchJobs(refresh: true);
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                        if (vm.isFetchingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    RecruiterJobsViewModel vm,
    bool isDark,
  ) {
    final filters = [
      {'label': 'All', 'status': 'all', 'icon': Icons.apps_rounded},
      {
        'label': 'Active',
        'status': 'active',
        'icon': Icons.check_circle_outline,
      },
      {'label': 'Draft', 'status': 'draft', 'icon': Icons.edit_outlined},
      {'label': 'Expired', 'status': 'expired', 'icon': Icons.cancel_outlined},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final idx = entry.key;
          final f = entry.value;
          return Padding(
            padding: EdgeInsets.only(left: idx == 0 ? 0 : 10),
            child: _filterChip(
              context,
              vm,
              isDark,
              label: f['label'] as String,
              status: f['status'] as String,
              icon: f['icon'] as IconData,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _filterChip(
    BuildContext context,
    RecruiterJobsViewModel vm,
    bool isDark, {
    required String label,
    required String status,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isSelected = vm.currentFilter == status;
    final Color activeColor = AppColors.lightPrimary;

    return GestureDetector(
      onTap: () => vm.setFilter(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? activeColor
                  : (isDark ? Colors.white54 : Colors.black45),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? activeColor
                    : (isDark ? Colors.white70 : Colors.black54),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
