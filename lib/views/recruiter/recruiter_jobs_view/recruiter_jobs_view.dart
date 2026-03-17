import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/views/recruiter/recruiter_jobs_view/widgets/jobs_card_widget.dart';
import 'package:jooblie_app/widgets/buttons/primary_button_with_icon.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/recruiter_dashboard_viewmodel.dart';

class RecruiterJobsView extends StatelessWidget {
  const RecruiterJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecruiterJobsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 100),
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingTextWidget(theme: theme, title: 'My Job Posts'),
                      4.h,
                      SubTitleWidget(
                        theme: theme,
                        subTitle: 'Manage your active job listings.',
                      ),
                    ],
                  ),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: PrimaryButtonWithIcon(
                    btnText: 'New job',
                    icon: Icons.add, onTap: () {  },
                  ),
                ),
              ],
            ),
          ),
          24.h,
          ...vm.jobs.asMap().entries.map((entry) {
            final idx = entry.key;
            final job = entry.value;
            return FadeInUp(
              delay: Duration(milliseconds: 150 + idx * 120),
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: JobPostCard(
                  job: job,
                  onDelete: () => vm.deleteJob(job.id),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
