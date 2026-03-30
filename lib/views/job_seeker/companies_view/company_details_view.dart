import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/jobseeker_home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../models/company_model.dart';
import '../../../models/job_recommendation_model.dart';
import '../../../viewmodels/companies_viewmodel.dart';
import '../job_seeker_jobs_view/widgets/job_details_bottom_sheet.dart';

class CompanyDetailsView extends StatefulWidget {
  final CompanyModel company;

  const CompanyDetailsView({super.key, required this.company});

  @override
  State<CompanyDetailsView> createState() => _CompanyDetailsViewState();
}

class _CompanyDetailsViewState extends State<CompanyDetailsView> {
  List<JobRecommendationModel> _jobs = [];
  bool _isLoadingJobs = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final jobs = await context.read<CompaniesViewModel>().fetchCompanyJobs(
      widget.company.name,
    );
    if (mounted) {
      setState(() {
        _jobs = jobs.map((j) => JobRecommendationModel.fromJson(j)).toList();
        _isLoadingJobs = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.gradientPrimary),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.business_rounded,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // ── Company Info ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.company.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.h,
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.blue[400],
                            ),
                            6.w,
                            Text(
                              widget.company.location,
                              style: theme.textTheme.bodyMedium,
                            ),
                            if (widget.company.industry != null) ...[
                              16.w,
                              Icon(
                                Icons.category_outlined,
                                size: 18,
                                color: Colors.blue[400],
                              ),
                              6.w,
                              Text(
                                widget.company.industry!,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  24.h,

                  // Stats Row
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Row(
                      children: [
                        _infoChip(
                          Icons.people_outline,
                          widget.company.companySize ?? 'N/A',
                          'Employees',
                          isDark,
                        ),
                        16.w,
                        _infoChip(
                          Icons.work_outline,
                          '${widget.company.openJobsCount}',
                          'Open Jobs',
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  32.h,

                  // About Section
                  if (widget.company.about != null &&
                      widget.company.about!.isNotEmpty) ...[
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          12.h,
                          Text(
                            widget.company.about!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    32.h,
                  ],

                  // Jobs Section Header
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      'Hiring Jobs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  16.h,
                ],
              ),
            ),
          ),

          // ── Jobs List ──
          if (_isLoadingJobs)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_jobs.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_off_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      16.h,
                      const Text('No active jobs found for this company.'),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final job = _jobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _jobTile(job, theme, isDark),
                  );
                }, childCount: _jobs.length),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String value, String label, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            8.h,
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            4.h,
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobTile(JobRecommendationModel job, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () => JobDetailsBottomSheet.show(context, job),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  4.h,
                  Text(
                    job.salaryRange,
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.h,
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      4.w,
                      Text(
                        job.location,
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      12.w,
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      4.w,
                      Text(
                        job.postedTime,
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
