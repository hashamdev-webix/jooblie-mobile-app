import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../../viewmodels/favorites_viewmodel.dart';
import '../../../../models/job_recommendation_model.dart';
import '../../../../core/app_colors.dart';
import '../../../../services/api_service.dart';
import '../../../../models/apply_job_request.dart';
import '../../../../viewmodels/jobseeker_applications_viewmodel.dart';
import '../../../../viewmodels/jobseeker_resume_viewmodel.dart';

class JobDetailsBottomSheet extends StatelessWidget {
  final JobRecommendationModel job;
  final bool isDark;

  const JobDetailsBottomSheet({
    Key? key,
    required this.job,
    required this.isDark,
  }) : super(key: key);

  static void show(BuildContext context, JobRecommendationModel job) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobDetailsBottomSheet(job: job, isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.90,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          // Main Scrollable Content
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: [
                // Header Area with Back Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Drag Handle
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance the back button
                  ],
                ),
                const SizedBox(height: 12),

                // Header Top Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business,
                        // Assuming business icon, screenshot had a building/document icon
                        color: AppColors.lightPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title and Company
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.company,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Map & Salary
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    Text(
                      job.salaryRange,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Time Posted & FullTime
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job.postedTime,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.work_outline,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job.jobType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Consumer<FavoritesViewModel>(
                  builder: (context, favViewModel, child) {
                    final isFavorite = favViewModel.isFavorite(job.id);
                    return Row(
                      children: [
                        _IconBtn(
                          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                          isDark: isDark,
                          iconColor: isFavorite ? Colors.red : null,
                          onTap: () => favViewModel.toggleFavorite(job),
                        ),
                        const SizedBox(width: 12),
                        Builder(
                          builder: (btnCtx) {
                            return _IconBtn(
                              icon: Icons.share_outlined,
                              isDark: isDark,
                              onTap: () {
                                final box = btnCtx.findRenderObject() as RenderBox?;
                                final rect = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
                                DeepLinkService.shareJob(job.title, job.id, sharePositionOrigin: rect);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Tags
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: job.tags.map((tag) => _TagChip(tag: tag)).toList(),
                ),
                const SizedBox(height: 24),

                // Description
                _SectionTitle('Description', theme),
                const SizedBox(height: 8),
                Text(
                  job.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Requirements
                _SectionTitle('Requirements', theme),
                const SizedBox(height: 8),
                ...job.requirements.map(
                  (req) => _BulletPoint(text: req, isDark: isDark),
                ),
                const SizedBox(height: 24),

                // Benefits
                _SectionTitle('Benefits', theme),
                const SizedBox(height: 8),
                ...job.benefits.map(
                  (ben) => _BulletPoint(text: ben, isDark: isDark),
                ),

                // Extra padding for scroll space
                const SizedBox(height: 40),
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 24,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white12 : Colors.black12,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<JobseekerApplicationsViewModel>(
                    builder: (context, appViewModel, child) {
                      final hasApplied = appViewModel.hasApplied(job.id);
                      final isLoading = appViewModel.isLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (hasApplied || isLoading)
                              ? null
                              : () => _handleApply(context, job, isDark),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasApplied
                                ? Colors.grey
                                : AppColors.lightPrimary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
                            disabledForegroundColor: isDark ? Colors.white54 : Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  hasApplied ? 'Applied' : 'Apply Now',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Consumer<FavoritesViewModel>(
                    builder: (context, favViewModel, child) {
                      final isSaved = favViewModel.isFavorite(job.id);
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => favViewModel.toggleFavorite(job),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : Colors.black87,
                            side: BorderSide(
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isSaved ? 'Job Saved' : 'Save Job',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final Color? iconColor;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.isDark,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? (isDark ? Colors.white70 : Colors.black87),
          size: 22,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: AppColors.lightPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionTitle(this.title, this.theme);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final bool isDark;

  const _BulletPoint({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _handleApply(BuildContext context, JobRecommendationModel job, bool isDark) async {
  final TextEditingController coverLetterController = TextEditingController();
  
  final bool? shouldApply = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      title: Text('Apply for Job', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Write a short cover letter for ${job.title} at ${job.company}:',
               style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14)),
            const SizedBox(height: 12),
            TextField(
              controller: coverLetterController,
              maxLines: 4,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'I would be a great fit because...',
                hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Text('Resume', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black, fontSize: 16)),
            const SizedBox(height: 8),
            Consumer<JobseekerResumeViewModel>(
              builder: (consumerCtx, rVm, child) {
                if (rVm.isUploading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final hasResume = rVm.currentResume != null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasResume) ...[
                      Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rVm.currentResume!.fileName ?? 'Resume.pdf',
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (rVm.currentResume!.fileSize.isNotEmpty)
                                  Text(
                                    rVm.currentResume!.fileSize,
                                    style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => rVm.pickAndUpload(),
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: const Text('Change Resume'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ] else ...[
                      const Text('A resume is required to apply for this job.', 
                           style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => rVm.pickAndUpload(),
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: const Text('Upload Resume'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightPrimary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Cancel', style: TextStyle(color: AppColors.lightPrimary)),
        ),
        ElevatedButton(
          onPressed: () {
             final currentResumeVm = Provider.of<JobseekerResumeViewModel>(ctx, listen: false);
             if (currentResumeVm.currentResume == null) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Please upload a resume first to apply.')),
                );
                return;
             }
             Navigator.pop(ctx, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Submit Application'),
        ),
      ],
    ),
  );

  if (shouldApply == true) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final request = ApplyJobRequest(coverLetter: coverLetterController.text);
      await ApiService().applyForJob(job.id, request);
      
      if (context.mounted) Navigator.pop(context); // pop loading
      if (context.mounted) Navigator.pop(context); // pop bottom sheet
      
      if (context.mounted) {
         try {
           Provider.of<JobseekerApplicationsViewModel>(context, listen: false).fetchApplications();
         } catch(e) { }
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Successfully applied to ${job.company}!')),
         );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Failed to apply. Please try again.')),
         );
      }
    }
  }
}
