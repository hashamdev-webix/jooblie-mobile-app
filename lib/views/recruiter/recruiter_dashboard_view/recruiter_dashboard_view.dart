import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/views/recruiter/recruiter_dashboard_view/widgets/stat_card_widget.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/recruiter_dashboard_viewmodel.dart';
import 'widgets/dashboard_aplicant_tile_widget.dart';
import 'widgets/card_width_list_tile.dart';

class RecruiterDashboardView extends StatelessWidget {
  const RecruiterDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final recruiterVM = context.watch<RecruiterDashboardViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statsList = [
      {
        "icon": Icons.work_outline,
        "value": recruiterVM.activeJobs.toString(),
        "label": "Active Jobs",
        "change": recruiterVM.activeJobsChange,
      },
      {
        "icon": Icons.people_outline,
        "value": recruiterVM.totalApplicants.toString(),
        "label": "Total Applicants",
        "change": recruiterVM.totalApplicantsChange,
      },
      {
        "icon": Icons.remove_red_eye_outlined,
        "value": recruiterVM.jobViews,
        "label": "Job Views",
        "change": recruiterVM.jobViewsChange,
      },
      {
        "icon": Icons.trending_up_rounded,
        "value": recruiterVM.hireRate,
        "label": "Hire Rate",
        "change": recruiterVM.hireRateChange,
      },
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            HeaderAppBarWidget(theme: theme, isDark: isDark,
            showSetting: false,
              showProfileIcon: true,
              showLeadingIcon: false,
            ),

            Expanded(
              child: ListView(
                padding:AppPadding.dashBoardPadding,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingTextWidget(
                          theme: theme,
                          title: "Recruiter Dashboard",
                        ),
                        4.h,
                        SubTitleWidget(
                          subTitle: 'Manage your hiring pipeline efficiently.',
                          theme: theme,
                        ),
                      ],
                    ),
                  ),
                  24.h,
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

                  FadeInLeft(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 400),
                    child: CardWithListTile(
                      theme: theme,
                      isDark: isDark,
                      title: 'Recent Applicants',
                      items: recruiterVM.recentApplicants,
                      itemBuilder: (context, item, index) =>
                          DashboardApplicantTileWidget(applicant: item),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
