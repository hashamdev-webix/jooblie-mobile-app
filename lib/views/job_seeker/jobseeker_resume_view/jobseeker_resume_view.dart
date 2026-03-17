import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/my_slide_animation.dart';
import 'package:jooblie_app/views/job_seeker/jobseeker_resume_view/widgets/current_resume_card_widget.dart';
import 'package:jooblie_app/views/job_seeker/jobseeker_resume_view/widgets/resume_upload_card_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/jobseeker_resume_viewmodel.dart';

class JobseekerResumeView extends StatelessWidget {
  const JobseekerResumeView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobseekerResumeViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkGradientBackground
            : AppColors.lightGradientBackground,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingTextWidget(theme: theme, title: 'My Resume'),
                    4.h,
                    SubTitleWidget(
                      theme: theme,
                      subTitle:
                          'Upload and manage your resume to apply for jobs faster.',
                    ),
                  ],
                ),
              ),
              20.h,

              // ── Upload Card ──
              MySlideTransition(
                child: ResumeUploadCardWidget(
                  theme: theme,
                  isDark: isDark,
                  vm: vm,
                ),
              ),

              if (vm.currentResume != null) ...[
                const SizedBox(height: 16),

                // ── Current Resume Card ──
                MySlideTransition(
                  child: CurrentResumeCardWidget(
                    theme: theme,
                    isDark: isDark,
                    vm: vm,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
