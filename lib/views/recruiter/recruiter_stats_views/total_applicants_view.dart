import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/recruiter_stats_detail_viewmodel.dart';
import '../../../widgets/header_appbar_widget.dart';
import '../../../widgets/heading_text_widget.dart';
import '../../../widgets/subtitle_widget.dart';
import '../recruiter_dashboard_view/widgets/dashboard_aplicant_tile_widget.dart';
import 'package:animate_do/animate_do.dart';
import '../../../widgets/custom_shimmer_widget.dart';

class TotalApplicantsView extends StatefulWidget {
  const TotalApplicantsView({super.key});

  @override
  State<TotalApplicantsView> createState() => _TotalApplicantsViewState();
}

class _TotalApplicantsViewState extends State<TotalApplicantsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecruiterStatsDetailViewModel>().fetchTotalApplicants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecruiterStatsDetailViewModel>();
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
              showProfileIcon: false,
              showLeadingIcon: true,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: vm.fetchTotalApplicants,
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
                          HeadingTextWidget(theme: theme, title: 'Total Applicants'),
                          4.h,
                          SubTitleWidget(
                            subTitle: 'All applicants across your active jobs.',
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                    24.h,
                    if (vm.isLoadingApplicants && vm.allApplicants.isEmpty)
                      ...List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomShimmerWidget.rectangular(
                            height: 80,
                            isDark: isDark,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      )
                    else if (vm.allApplicants.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 60,
                                color: isDark
                                    ? AppColors.darkMutedForeground
                                    : AppColors.lightMutedForeground,
                              ),
                              16.h,
                              Text(
                                'No applicants found.',
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
                    else
                      ...vm.allApplicants.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final applicant = entry.value;
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 + (idx % 10) * 80),
                          duration: const Duration(milliseconds: 500),
                          child: DashboardApplicantTileWidget(applicant: applicant),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
