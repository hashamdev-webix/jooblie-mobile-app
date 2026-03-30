import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../models/job_recommendation_model.dart';
import '../../../../viewmodels/favorites_viewmodel.dart';

class JobCardWidget extends StatelessWidget {
  final JobRecommendationModel job;
  final VoidCallback onTap;

  const JobCardWidget({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Icon Placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.business_center_rounded,
                    color: AppColors.lightPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),

                // Job Title
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  // Space for heart icon
                  child: Text(
                    job.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Company
                Text(
                  job.company,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.tags.map((tag) => _BuildTag(tag: tag)).toList(),
                ),
                const SizedBox(height: 16),

                // Details Row
                Row(
                  children: [
                    _buildInfoItem(
                      Icons.location_on_outlined,
                      job.location,
                      isDark,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoItem(
                      Icons.attach_money_rounded,
                      job.salaryRange,
                      isDark,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoItem(
                      Icons.access_time_rounded,
                      job.postedTime,
                      isDark,
                    ),
                  ],
                ),
              ],
            ),

            // Favorite Button
            Positioned(
              top: 0,
              right: 0,
              child: Consumer<FavoritesViewModel>(
                builder: (context, favViewModel, child) {
                  final isSaved = favViewModel.isFavorite(job.id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved
                          ? Colors.red
                          : (isDark ? Colors.white38 : Colors.black26),
                    ),
                    onPressed: () => favViewModel.toggleFavorite(job),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.white60 : Colors.black45),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black45,
          ),
        ),
      ],
    );
  }
}

class _BuildTag extends StatelessWidget {
  final String tag;

  const _BuildTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: AppColors.lightPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
