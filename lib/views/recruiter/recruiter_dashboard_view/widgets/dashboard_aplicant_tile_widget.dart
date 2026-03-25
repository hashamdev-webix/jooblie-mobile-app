import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_post_model.dart';
import 'package:jooblie_app/widgets/app_logo_widget.dart';
import 'package:provider/provider.dart';
import 'package:jooblie_app/viewmodels/recruiter_dashboard_viewmodel.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardApplicantTileWidget extends StatelessWidget {
  final RecentApplicant applicant;

  const DashboardApplicantTileWidget({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Record the profile view when the recruiter taps on the applicant card
        context.read<RecruiterDashboardViewModel>().recordProfileView(applicant.applicantId);
        
        // Navigate to applicant detail view
        Navigator.pushNamed(
          context, 
          RoutesName.applicantDetail, 
          arguments: applicant.applicationId,
        ).then((_) {
          // Refresh dashboard data when returning from detail view
          if (context.mounted) {
            context.read<RecruiterDashboardViewModel>().fetchStats();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Color(0xff141D2C) : Color(0xffF5F9FC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            AppLogo(
              width: 30,
              height: 30,
              borderRadius: 20,
              child: Center(
                child: Text(
                  applicant.avatarInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        applicant.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (applicant.resumeUrl != null) ...[
                        4.w,
                        Tooltip(
                          message: 'View Resume',
                          child: Consumer<ApplicantDetailViewModel>(
                            builder: (context, detailVm, child) {
                              return InkWell(
                                onTap: () async {
                                  if (applicant.resumeUrl != null) {
                                    await detailVm.downloadAndOpenResume(
                                      applicant.resumeUrl!, 
                                      '${applicant.name.replaceAll(' ', '_')}_Resume.pdf',
                                    );
                                  }
                                },
                                child: detailVm.isDownloading 
                                  ? const SizedBox(
                                      width: 16, 
                                      height: 16, 
                                      child: CircularProgressIndicator(strokeWidth: 1),
                                    )
                                  : Icon(Icons.picture_as_pdf_outlined, 
                                      size: 16, color: AppColors.lightPrimary),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  4.h,
                  Text(
                    applicant.jobTitle != null 
                      ? 'Applied for: ${applicant.jobTitle}'
                      : applicant.role,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkMutedForeground
                          : AppColors.lightMutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (applicant.status == 'Rejected' ? Colors.red : AppColors.lightSecondary)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (applicant.status == 'Rejected' ? Colors.red : AppColors.lightSecondary)
                      .withOpacity(0.4),
                ),
              ),
              child: Text(
                applicant.status ?? 'Pending',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: applicant.status == 'Rejected' ? Colors.red : AppColors.lightSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
