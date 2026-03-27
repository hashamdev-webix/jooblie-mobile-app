import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/jobseeker_home_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../viewmodels/favorites_viewmodel.dart';
import '../job_seeker_jobs_view/widgets/job_card_widget.dart';
import '../job_seeker_recommendation_view/widgets/job_details_bottom_sheet.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favViewModel = context.watch<FavoritesViewModel>();
    final favoriteJobs = favViewModel.favoriteJobs;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Favorite Jobs',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favViewModel.isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.lightPrimary),
            )
          : favViewModel.favoriteJobs.isEmpty
          ? _buildEmptyState(theme, isDark)
          : RefreshIndicator(
              onRefresh: () => favViewModel.fetchFavoriteJobs(),
              color: AppColors.lightPrimary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: favoriteJobs.length,
                itemBuilder: (context, index) {
                  final job = favoriteJobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: JobCardWidget(
                      job: job,
                      onTap: () => JobDetailsBottomSheet.show(context, job),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorites yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Save your favorite jobs to view them later and stay organized.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
