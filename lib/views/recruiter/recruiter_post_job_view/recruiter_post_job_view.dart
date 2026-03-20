import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/views/recruiter/recruiter_post_job_view/widgets/recruiter_post_job_drop_down.dart';
import 'package:jooblie_app/views/recruiter/recruiter_post_job_view/widgets/recruiter_post_job_form_card.dart';
import 'package:jooblie_app/views/recruiter/recruiter_post_job_view/widgets/recruiter_post_job_form_field.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:jooblie_app/widgets/heading_text_widget.dart';
import 'package:jooblie_app/widgets/primary_button.dart';
import 'package:jooblie_app/widgets/subtitle_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/recruiter_dashboard_viewmodel.dart';

class RecruiterPostJobView extends StatelessWidget {
  const RecruiterPostJobView({super.key});

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint,
    IconData? icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      fillColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
      filled: true,
      hintStyle: TextStyle(
        color: isDark
            ? AppColors.darkMutedForeground
            : AppColors.lightMutedForeground,
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.lightError, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.lightError, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecruiterPostJobViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                child: Form(
                  key: vm.formKey,
                  child: ListView(
                    padding: AppPadding.dashBoardPadding,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeadingTextWidget(
                              theme: theme,
                              title: "Post a New Job",
                            ),
                            4.h,
                            SubTitleWidget(
                              theme: theme,
                              subTitle:
                                  "Create a compelling job listing to attract top talent.",
                            ),
                          ],
                        ),
                      ),
                      24.h,

                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        duration: const Duration(milliseconds: 500),
                        child: RecruiterPostJobFormCard(
                          isDark: isDark,
                          children: [
                            RecruiterPostJobFormField(
                              label: 'Job Title',
                              child: TextFormField(
                                initialValue: vm.jobTitle.isNotEmpty ? vm.jobTitle : null,
                                decoration: _inputDecoration(
                                  context,
                                  'e.g. Senior React Developer',
                                  Icons.work_outline,
                                ),
                                textInputAction: TextInputAction.next,
                                onSaved: (v) => vm.jobTitle = v ?? '',
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Company Name',
                              child: TextFormField(
                                initialValue: vm.companyName.isNotEmpty ? vm.companyName : null,
                                decoration: _inputDecoration(
                                  context,
                                  'e.g. TechCorp Inc.',
                                  Icons.business_outlined,
                                ),
                                textInputAction: TextInputAction.next,
                                onSaved: (v) => vm.companyName = v ?? '',
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Location',
                              child: TextFormField(
                                initialValue: vm.location.isNotEmpty ? vm.location : null,
                                decoration: _inputDecoration(
                                  context,
                                  'Remote, City, etc.',
                                  Icons.location_on_outlined,
                                ),
                                textInputAction: TextInputAction.next,
                                onSaved: (v) => vm.location = v ?? '',
                              ),
                            ),
                            24.h,
                            Row(
                              children: [
                                Expanded(
                                  child: RecruiterPostJobFormField(
                                    label: 'Min Salary',
                                    child: TextFormField(
                                      initialValue: vm.salaryMin.isNotEmpty ? vm.salaryMin : null,
                                      decoration: _inputDecoration(
                                        context,
                                        '\$100K',
                                        Icons.attach_money_outlined,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSaved: (v) => vm.salaryMin = v ?? '',
                                    ),
                                  ),
                                ),
                                12.w,
                                Expanded(
                                  child: RecruiterPostJobFormField(
                                    label: 'Max Salary',
                                    child: TextFormField(
                                      initialValue: vm.salaryMax.isNotEmpty ? vm.salaryMax : null,
                                      decoration: _inputDecoration(
                                        context,
                                        '\$150K',
                                        Icons.attach_money_outlined,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSaved: (v) => vm.salaryMax = v ?? '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Job Type',
                              child: RecruiterPostJObDropdown<String>(
                                value: vm.jobType,
                                items: vm.jobTypes,
                                onChanged: (v) {
                                  if (v != null) vm.setJobType(v);
                                },
                                isDark: isDark,
                              ),
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Experience Level',
                              child: RecruiterPostJObDropdown<String>(
                                value: vm.experienceLevel,
                                items: vm.experienceLevels,
                                onChanged: (v) {
                                  if (v != null) vm.setExperienceLevel(v);
                                },
                                isDark: isDark,
                              ),
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Job Description',
                              child: TextFormField(
                                initialValue: vm.description.isNotEmpty ? vm.description : null,
                                decoration: _inputDecoration(
                                  context,
                                  "Describe the role, responsibilities, and what you're looking for...",
                                  null,
                                ),
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                onSaved: (v) => vm.description = v ?? '',
                              ),
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Requirements',
                              child: TextFormField(
                                initialValue: vm.requirements.isNotEmpty ? vm.requirements : null,
                                decoration: _inputDecoration(
                                  context,
                                  "List the key qualifications and requirements...",
                                  null,
                                ),
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                onSaved: (v) => vm.requirements = v ?? '',
                              ),
                            ),
                            24.h,
                            RecruiterPostJobFormField(
                              label: 'Required Skills',
                              child: TextFormField(
                                initialValue: vm.skills.isNotEmpty ? vm.skills : null,
                                decoration: _inputDecoration(
                                  context,
                                  'React, TypeScript, Node.js (comma-separated)',
                                  null,
                                ),
                                textInputAction: TextInputAction.done,
                                onSaved: (v) => vm.skills = v ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),

                      28.h,

                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: "Publish Job",
                                icon: Icons.save,

                                onPressed: vm.isLoading
                                    ? null
                                    : () async {
                                        final success = await vm.publishJob();
                                        if (success && context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Job published successfully!',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                isLoading: vm.isLoading,
                              ),
                            ),
                            12.w,
                            Expanded(
                              child: OutlinedButton(
                                onPressed: vm.isLoading
                                    ? null
                                    : () async {
                                        await vm.saveDraft();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Draft saved.'),
                                            ),
                                          );
                                        }
                                      },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Save Draft',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
