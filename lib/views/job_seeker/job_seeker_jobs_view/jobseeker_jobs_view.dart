import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/widgets/custom_home_search_bar.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../viewmodels/job_seeker_jobs_viewmodel.dart';
import '../../../core/sized.dart';
import '../job_seeker_recommendation_view/widgets/job_details_bottom_sheet.dart';
import 'widgets/job_card_widget.dart';
import 'widgets/jobs_search_header.dart';

class JobSeekerJobsView extends StatelessWidget {
  const JobSeekerJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobSeekerJobsViewModel>();
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
              // Header section with Browse Jobs title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Browse ',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Jobs',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
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
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomHomeSearchBar(
                              onSearchTap: () => Navigator.pushNamed(context, RoutesName.search),
                              onLocationTap: () => Navigator.pushNamed(context, RoutesName.search),
                            ),
                            10.h,
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.filter_list_rounded, size: 20),
                                label: const Text(
                                  'Filters',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isDark ? Colors.white70 : Colors.black54,
                                  side: BorderSide(
                                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    15.h,
                    // FadeInUp(
                    //   duration: const Duration(milliseconds: 600),
                    //   child: const JobsSearchHeader(),
                    // ),
                    // const SizedBox(height: 24),

                    // Job Cards list
                    ...vm.jobs.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final job = entry.value;
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * idx),
                        duration: const Duration(milliseconds: 500),
                        child: JobCardWidget(
                          job: job,
                          onTap: () {
                            JobDetailsBottomSheet.show(context, job);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.lightPrimary,
        child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
      ),
    );
  }
}
