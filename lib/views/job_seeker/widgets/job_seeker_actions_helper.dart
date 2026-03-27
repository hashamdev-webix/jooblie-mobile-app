import 'package:flutter/material.dart';
import 'package:jooblie_app/models/job_recommendation_model.dart';
import 'package:jooblie_app/services/views_service.dart';
import 'package:jooblie_app/viewmodels/jobseeker_applications_viewmodel.dart';
import 'package:jooblie_app/viewmodels/jobseeker_home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_recommendation_view/widgets/job_details_bottom_sheet.dart';
import 'package:jooblie_app/views/job_seeker/widgets/apply_job_dialog.dart';

class JobseekerActionsHelper {
  /// Shows the job details bottom sheet and records a view.
  static void showJobDetails(BuildContext context, JobRecommendationModel job) {
    ViewsService.recordJobView(job.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobDetailsBottomSheet(job: job, isDark: isDark),
    );
  }

  /// Handles the apply for job flow with a cover letter dialog and resume check.
  static Future<void> handleApply(
    BuildContext context,
    JobRecommendationModel job,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String? coverLetter = await showDialog<String>(
      context: context,
      builder: (ctx) => ApplyJobDialog(job: job, isDark: isDark),
    );

    if (coverLetter != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final homeVm = Provider.of<JobseekerHomeViewModel>(
          context,
          listen: false,
        );
        await homeVm.applyForJob(job.id, coverLetter);

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully applied to ${job.company}!')),
          );

          try {
            Provider.of<JobseekerApplicationsViewModel>(
              context,
              listen: false,
            ).fetchApplications();
          } catch (_) {}
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to apply. Please try again.')),
          );
        }
      }
    }
  }
}
