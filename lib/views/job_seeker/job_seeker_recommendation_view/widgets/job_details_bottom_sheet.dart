import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/models/job_recommendation_model.dart';
import 'package:jooblie_app/views/job_seeker/widgets/job_seeker_actions_helper.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../../viewmodels/favorites_viewmodel.dart';
import '../../../../viewmodels/jobseeker_applications_viewmodel.dart';

class JobDetailsBottomSheet extends StatelessWidget {
  final JobRecommendationModel job;
  final bool isDark;

  const JobDetailsBottomSheet({required this.job, required this.isDark});

  static void show(BuildContext context, JobRecommendationModel job) {
    JobseekerActionsHelper.showJobDetails(context, job);
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
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: [
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
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    48.w,
                  ],
                ),
                12.h,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business,
                        color: AppColors.lightPrimary,
                        size: 28,
                      ),
                    ),
                    15.w,
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

                          4.h,
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

                16.h,

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),

                    4.w,
                    Text(
                      job.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),

                    16.w,
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
                8.h,

                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),

                    4.w,
                    Text(
                      job.postedTime,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),

                    16.w,
                    Icon(
                      Icons.work_outline,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),

                    4.w,
                    const SizedBox(width: 4),
                    Text(
                      job.jobType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),

                16.h,

                Consumer<FavoritesViewModel>(
                  builder: (context, favViewModel, child) {
                    final isFavorite = favViewModel.isFavorite(job.id);
                    return Row(
                      children: [
                        _IconBtn(
                          icon: isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          isDark: isDark,
                          iconColor: isFavorite ? Colors.red : null,
                          onTap: () => favViewModel.toggleFavorite(job),
                        ),
                        12.w,
                        Builder(
                          builder: (btnCtx) {
                            return _IconBtn(
                              icon: Icons.share_outlined,
                              isDark: isDark,
                              onTap: () {
                                final box =
                                    btnCtx.findRenderObject() as RenderBox?;
                                final rect = box != null
                                    ? box.localToGlobal(Offset.zero) & box.size
                                    : null;
                                DeepLinkService.shareJob(
                                  job.title,
                                  job.id,
                                  sharePositionOrigin: rect,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                20.h,

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: job.tags.map((tag) => _TagChip(tag: tag)).toList(),
                ),

                24.h,

                _SectionTitle('Description', theme),
                8.h,
                Text(
                  job.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                ),
                24.h,

                _SectionTitle('Requirements', theme),
                8.h,
                ...job.requirements.map(
                  (req) => _BulletPoint(text: req, isDark: isDark),
                ),

                // const SizedBox(height: 24),

                // _SectionTitle('Benefits', theme),
                // const SizedBox(height: 8),
                // ...job.benefits.map(
                //   (ben) => _BulletPoint(text: ben, isDark: isDark),
                // ),
                40.h,
              ],
            ),
          ),

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
                              : () => JobseekerActionsHelper.handleApply(
                                  context,
                                  job,
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasApplied
                                ? Colors.grey
                                : AppColors.lightPrimary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade400,
                            disabledForegroundColor: isDark
                                ? Colors.white54
                                : Colors.white70,
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
                            foregroundColor: isDark
                                ? Colors.white
                                : Colors.black87,
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
