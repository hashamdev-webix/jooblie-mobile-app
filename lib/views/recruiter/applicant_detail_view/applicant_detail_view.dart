import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_post_model.dart';
import 'package:jooblie_app/viewmodels/recruiter_dashboard_viewmodel.dart';
import 'package:jooblie_app/widgets/custom_shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicantDetailView extends StatefulWidget {
  final String applicationId;

  const ApplicantDetailView({super.key, required this.applicationId});

  @override
  State<ApplicantDetailView> createState() => _ApplicantDetailViewState();
}

class _ApplicantDetailViewState extends State<ApplicantDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicantDetailViewModel>().fetchApplicationDetail(
        widget.applicationId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Applicant Details'), centerTitle: true),
      body: Consumer<ApplicantDetailViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return _buildShimmerLoading(context, isDark);
          }

          if (vm.error != null) {
            return Center(child: Text(vm.error!));
          }

          final app = vm.application;
          if (app == null) {
            return const Center(child: Text('No details found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Profile Info
                _buildProfileHeader(app, theme, isDark),
                24.h,

                // Status Selector
                _buildStatusSection(vm, app, theme, isDark),
                24.h,

                // Job Details
                _buildSectionTitle('Applied Job', theme),
                Text(
                  app.jobTitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                24.h,

                // Cover Letter
                if (app.coverLetter != null && app.coverLetter!.isNotEmpty) ...[
                  _buildSectionTitle('Cover Letter', theme),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkMuted.withOpacity(0.5)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : Colors.grey[200]!,
                      ),
                    ),
                    child: Text(
                      app.coverLetter!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                  24.h,
                ],

                // Resume
                _buildSectionTitle('Resume', theme),
                _buildResumeCard(app, theme, isDark),
                24.h,

                // About
                if (app.about.isNotEmpty) ...[
                  _buildSectionTitle('About', theme),
                  Text(
                    app.about,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  24.h,
                ],

                // Skills
                if (app.skills.isNotEmpty) ...[
                  _buildSectionTitle('Skills', theme),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: app.skills
                        .map((skill) => _buildSkillChip(skill, theme, isDark))
                        .toList(),
                  ),
                  40.h,
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomShimmerWidget.circular(
                width: 80,
                height: 80,
                isDark: isDark,
              ),
              16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerWidget.rectangular(
                      height: 24,
                      width: 200,
                      isDark: isDark,
                    ),
                    12.h,
                    CustomShimmerWidget.rectangular(
                      height: 16,
                      width: 150,
                      isDark: isDark,
                    ),
                    8.h,
                    CustomShimmerWidget.rectangular(
                      height: 16,
                      width: 100,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          32.h,
          CustomShimmerWidget.rectangular(
            height: 20,
            width: 150,
            isDark: isDark,
          ),
          16.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => CustomShimmerWidget.rectangular(
                height: 40,
                width: (MediaQuery.of(context).size.width - 60) / 3,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          32.h,
          CustomShimmerWidget.rectangular(
            height: 20,
            width: 150,
            isDark: isDark,
          ),
          16.h,
          CustomShimmerWidget.rectangular(height: 100, isDark: isDark),
          32.h,
          CustomShimmerWidget.rectangular(
            height: 20,
            width: 150,
            isDark: isDark,
          ),
          16.h,
          CustomShimmerWidget.rectangular(height: 80, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(app, ThemeData theme, bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.lightPrimary.withOpacity(0.1),
          backgroundImage: app.avatarUrl != null && app.avatarUrl.isNotEmpty
              ? NetworkImage(app.avatarUrl!)
              : null,
          child: app.avatarUrl == null || app.avatarUrl.isEmpty
              ? Text(
                  app.name[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.lightPrimary,
                  ),
                )
              : null,
        ),
        16.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                app.role,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              4.h,
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  4.w,
                  Text(app.location, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(
    ApplicantDetailViewModel vm,
    app,
    ThemeData theme,
    bool isDark,
  ) {
    final statuses = ['Pending', 'Interview', 'Rejected', 'Offer', 'Hired'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Application Status', theme),
        8.h,
        Wrap(
          spacing: 10,
          children: statuses.map((s) {
            final isSelected = app.status == s;
            return ChoiceChip(
              label: Text(s),
              selected: isSelected,
              onSelected: (selected) async {
                if (selected && app.status != s) {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final success = await vm.updateStatus(s);

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Status updated to $s'
                            : 'Failed to update status',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              selectedColor: _getStatusColor(s).withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? _getStatusColor(s)
                    : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResumeCard(ApplicationDetail app, ThemeData theme, bool isDark) {
    if (app.resumeUrl == null || app.resumeUrl!.isEmpty) {
      return const Text('No resume uploaded.');
    }

    return Consumer<ApplicantDetailViewModel>(
      builder: (context, vm, child) {
        return InkWell(
          onTap: vm.isDownloading
              ? null
              : () => vm.downloadAndOpenResume(
                  app.resumeUrl!,
                  '${app.name.replaceAll(' ', '_')}_Resume.pdf',
                ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.lightPrimary.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resume.pdf', style: theme.textTheme.titleSmall),
                      if (vm.isDownloading)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: LinearProgressIndicator(
                            value: vm.downloadProgress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.lightPrimary,
                            ),
                          ),
                        )
                      else
                        Text(
                          'Tap to download and open',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                vm.isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.download_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.lightPrimary,
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkMuted : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(skill, style: theme.textTheme.bodySmall),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Interview':
        return Colors.blue;
      case 'Rejected':
        return Colors.red;
      case 'Offer':
        return Colors.purple;
      case 'Hired':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
