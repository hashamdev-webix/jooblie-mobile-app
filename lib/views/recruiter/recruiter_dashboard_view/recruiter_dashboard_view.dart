import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/services/fcm_service.dart';
import 'package:jooblie_app/services/get_service_key.dart';
import 'package:jooblie_app/services/notifications_service.dart';
import 'package:jooblie_app/views/recruiter/recruiter_dashboard_view/widgets/stat_card_widget.dart';
import 'package:jooblie_app/widgets/custom_shimmer_widget.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/recruiter_dashboard_viewmodel.dart';
import 'widgets/dashboard_aplicant_tile_widget.dart';
import 'widgets/card_width_list_tile.dart';

class RecruiterDashboardView extends StatefulWidget {
  const RecruiterDashboardView({super.key});

  @override
  State<RecruiterDashboardView> createState() => _RecruiterDashboardViewState();
}

class _RecruiterDashboardViewState extends State<RecruiterDashboardView> {

  NotificationsService notificationsService = NotificationsService();

  @override
  void initState() {
    super.initState();
    FcmService.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecruiterDashboardViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final statsList = [
      {
        "icon": Icons.work_outline,
        "value": vm.activeJobs.toString(),
        "label": "Active Jobs",
        "change": "${vm.activeJobs} currently live",
      },
      {
        "icon": Icons.people_outline,
        "value": vm.totalApplicants.toString(),
        "label": "Total Applicants",
        "change": "Across all your jobs",
      },
      {
        "icon": Icons.remove_red_eye_outlined,
        "value": vm.jobViews.toString(),
        "label": "Job Views",
        "change": "Total impressions",
      },
      {
        "icon": Icons.trending_up_rounded,
        "value": "${vm.hireRate.toStringAsFixed(1)}%",
        "label": "Hire Rate",
        "change": "Hired vs applicants",
      },
    ];

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
                onRefresh: vm.fetchStats,
                color: AppColors.lightPrimary,
                child: ListView(
                  padding: AppPadding.dashBoardPadding,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingTextWidget(theme: theme, title: "Recruiter Dashboard"),
                          4.h,
                          SubTitleWidget(
                            subTitle: 'Manage your hiring pipeline efficiently.',
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                    24.h,

                    // Stat Cards — shimmer when loading
                    if (vm.isLoading)
                      ...List.generate(4, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomShimmerWidget.rectangular(
                          height: 80,
                          isDark: isDark,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ))
                    else
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: statsList.length,
                        itemBuilder: (context, index) {
                          final stat = statsList[index];
                          return Column(
                            children: [
                              FadeInUp(
                                delay: Duration(milliseconds: 100 * (index + 1)),
                                duration: const Duration(milliseconds: 500),
                                child: StatCardWidget(
                                  icon: stat["icon"] as IconData,
                                  value: stat["value"] as String,
                                  label: stat["label"] as String,
                                  change: stat["change"] as String,
                                ),
                              ),
                              12.h,
                            ],
                          );
                        },
                      ),

                    20.h,

                    // Top Performing Jobs
                    if (!vm.isLoading && vm.topJobs.isNotEmpty) ...[
                      FadeInLeft(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 400),
                        child: _TopJobsCard(theme: theme, isDark: isDark, vm: vm),
                      ),
                      20.h,
                    ],

                    // Recent Applicants
                    if (vm.isLoading)
                      CustomShimmerWidget.rectangular(
                        height: 180,
                        isDark: isDark,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      )
                    else
                      FadeInLeft(
                        delay: const Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 400),
                        child: vm.recentApplicants.isEmpty
                            ? _emptyApplicantsCard(theme, isDark)
                            : CardWithListTile(
                                theme: theme,
                                isDark: isDark,
                                title: 'Recent Applicants',
                                items: vm.recentApplicants,
                                itemBuilder: (context, item, index) =>
                                    DashboardApplicantTileWidget(applicant: item),
                              ),
                      ),

                    20.h,
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }

  Widget _emptyApplicantsCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 40,
                color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground),
            12.h,
            Text('No applicants yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground)),
          ],
        ),
      ),
    );
  }
}

class _TopJobsCard extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final RecruiterDashboardViewModel vm;

  const _TopJobsCard({required this.theme, required this.isDark, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
        boxShadow: [isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Performing Jobs',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          12.h,
          ...vm.topJobs.map((job) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.work_outline, size: 18, color: AppColors.lightPrimary),
                ),
                12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      4.h,
                      Text('${job.applicants} applicants · ${job.views} views',
                          style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
