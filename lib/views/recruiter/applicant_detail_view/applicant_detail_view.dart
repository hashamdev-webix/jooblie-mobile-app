import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_post_model.dart';
import 'package:jooblie_app/viewmodels/recruiter_dashboard_viewmodel.dart';
import 'package:jooblie_app/widgets/custom_shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:icons_plus/icons_plus.dart';

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
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: vm.isLoading && vm.application == null
                ? _buildShimmerLoading(context, isDark)
                : vm.error != null
                    ? Center(key: const ValueKey('error'), child: Text(vm.error!))
                    : vm.application == null
                        ? const Center(
                            key: ValueKey('empty'),
                            child: Text('No details found.'),
                          )
                        : _buildMainContent(vm, vm.application!, theme, isDark),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    ApplicantDetailViewModel vm,
    ApplicationDetail app,
    ThemeData theme,
    bool isDark,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('content'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Profile Info
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: _buildProfileHeader(app, theme, isDark),
          ),
          24.h,

          // Status Selector
          _buildStatusSection(vm, app, theme, isDark),
          24.h,

          // Job Details
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Applied Job', theme),
                Text(
                  app.jobTitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          24.h,

          // Cover Letter
          if (app.coverLetter != null && app.coverLetter!.isNotEmpty) ...[
            FadeInLeft(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        color: isDark ? AppColors.darkBorder : Colors.grey[200]!,
                      ),
                    ),
                    child: Text(
                      app.coverLetter!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            24.h,
          ],

          // Resume
          _buildResumeCard(app, theme, isDark),
          24.h,

          // About
          if (app.about.isNotEmpty) ...[
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About', theme),
                  Text(
                    app.about,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            24.h,
          ],

          // Skills
          if (app.skills.isNotEmpty) ...[
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Skills', theme),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: app.skills
                        .map((skill) => _buildSkillChip(skill, theme, isDark))
                        .toList(),
                  ),
                ],
              ),
            ),
            40.h,
          ],
        ],
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
    ApplicationDetail app,
    ThemeData theme,
    bool isDark,
  ) {
    final statuses = ['Pending', 'Interview', 'Rejected', 'Offer', 'Hired'];

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Application Status', theme),
              if (vm.isUpdatingStatus)
                 SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightPrimary),
                  ),
                ),
            ],
          ),
          8.h,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statuses.map((s) {
                final isSelected = app.status == s;
                final statusColor = _getStatusColor(s);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AbsorbPointer(
                    absorbing: vm.isUpdatingStatus,
                    child: InkWell(
                      onTap: () async {
                      if (app.status != s) {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final success = await vm.updateStatus(s);

                        if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Status updated to $s'
                                    : 'Failed to update status',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? statusColor.withOpacity(0.15)
                            : isDark
                                ? AppColors.darkMuted
                                : Colors.grey[50],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? statusColor
                              : isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: statusColor,
                            ),
                            6.w,
                          ],
                          Text(
                            s,
                            style: TextStyle(
                              color: isSelected
                                  ? statusColor
                                  : (isDark ? Colors.white70 : Colors.black87),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(ApplicationDetail app, ThemeData theme, bool isDark) {
    if (app.resumeUrl == null || app.resumeUrl!.isEmpty) {
      return const Text('No resume uploaded.');
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 300),
      child: Consumer<ApplicantDetailViewModel>(
        builder: (context, vm, child) {
          return InkWell(
            onTap: vm.isDownloading
                ? null
                : () => vm.downloadAndOpenResume(
                      app.resumeUrl!,
                      '${app.name.replaceAll(' ', '_')}_Resume.pdf',
                    ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkMuted : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.grey[200]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Document Placeholder (The "Thumbnail")
                  Container(
                    width: 80,
                    height: 96,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Bootstrap.file_earmark_pdf_fill,
                          color: Colors.red.shade400,
                          size: 40,
                        ),
                      Positioned(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.w,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${app.name.split(' ').first}_Resume.pdf',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.h,
                        Text(
                          vm.isDownloading
                              ? 'Downloading... ${(vm.downloadProgress * 100).toInt()}%'
                              : 'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: vm.isDownloading ? AppColors.lightPrimary : Colors.grey,
                            fontWeight: vm.isDownloading ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (vm.isDownloading) ...[
                          10.h,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: vm.downloadProgress > 0 ? vm.downloadProgress : null,
                              minHeight: 4,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.lightPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: vm.isDownloading
                        ?  SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightPrimary),
                            ),
                          )
                        : Icon(
                            Bootstrap.download,
                            size: 18,
                            color: AppColors.lightPrimary,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
