import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../core/utils/routes_name.dart';
import '../models/home_stats_model.dart';
import '../models/dashboard_stats_model.dart';
import '../repositories/jobseeker_repository.dart';

class JobseekerHomeViewModel extends ChangeNotifier {
  final JobseekerRepository _repository = JobseekerRepository();

  bool isLoading = false;
  String userName = '';
  String? error;
  DashboardStats? dashboardStats;

  List<HomeStatModel> stats = [
    const HomeStatModel(
      label: 'Applications',
      count: 0,
      badge: 'Total applied',
      iconAsset: 'applications',
    ),
    const HomeStatModel(
      label: 'Interviews',
      count: 0,
      badge: 'Scheduled',
      iconAsset: 'interviews',
    ),
    const HomeStatModel(
      label: 'Saved Jobs',
      count: 0,
      badge: 'Bookmarked',
      iconAsset: 'saved',
    ),
    const HomeStatModel(
      label: 'Profile Views',
      count: 0,
      badge: 'From recruiters',
      iconAsset: 'views',
    ),
  ];

  List<RecentApplicationModel> recentApplications = [];

  JobseekerHomeViewModel() {
    fetchStats();
  }

  /// Fetches all stats and recent applications for the home screen.
  Future<void> fetchStats() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      // Parallel data fetching for performance
      final results = await Future.wait([
        _repository.getApplications(user.id),
        _repository.getProfileViewsCount(user.id),
        _repository.getSavedJobsCount(user.id),
        _repository.getProfileName(user.id),
        _repository.getAppliedJobViewsCount(user.id),
      ]);

      final allApps = results[0] as List<Map<String, dynamic>>;
      final pViewsCount = results[1] as int;
      final savedJobsCount = results[2] as int;
      final profileName = results[3] as String?;
      final appliedJobViewsCount = results[4] as int;

      // 1. Process Applications
      int totalApps = allApps.length;
      int activeApps = allApps
          .where(
            (app) => app['status'] != 'Rejected' && app['status'] != 'Archived',
          )
          .length;
      int interviews = allApps
          .where((app) => app['status'] == 'Interview')
          .length;
      int offers = allApps.where((app) => app['status'] == 'Offer').length;

      // 2. Process User Name
      if (profileName != null && profileName.isNotEmpty) {
        userName = profileName.split(' ').first;
      } else {
        userName =
            user.userMetadata?['full_name']?.toString().split(' ').first ??
            'there';
      }

      // 3. Application Status Distribution
      final Map<String, int> statusCounts = {};
      for (var app in allApps) {
        final st = app['status']?.toString() ?? 'Pending';
        statusCounts[st] = (statusCounts[st] ?? 0) + 1;
      }
      final List<ApplicationStatusCount> byStatus = statusCounts.entries
          .map((e) => ApplicationStatusCount(status: e.key, count: e.value))
          .toList();

      // 4. Recent Applications (Top 5)
      allApps.sort((a, b) {
        final d1 = a['created_at'] != null
            ? DateTime.parse(a['created_at'])
            : DateTime.now();
        final d2 = b['created_at'] != null
            ? DateTime.parse(b['created_at'])
            : DateTime.now();
        return d2.compareTo(d1);
      });

      final topApps = allApps.take(5).toList();

      recentApplications = topApps.map((json) {
        final job = json['jobs'] ?? {};
        String formattedDate = '';
        if (json['created_at'] != null) {
          try {
            final dt = DateTime.parse(json['created_at']);
            formattedDate = DateFormat('MMM d, yyyy').format(dt);
          } catch (_) {}
        }
        return RecentApplicationModel(
          title: job['title']?.toString() ?? 'Unknown Role',
          company: job['company_name']?.toString() ?? 'Unknown Company',
          status: json['status']?.toString() ?? 'Applied',
          date: formattedDate,
        );
      }).toList();

      // 5. Recent Activity
      final recentActs = topApps.map((a) {
        return RecentActivity(
          type: 'application',
          description: 'Applied for ${(a['jobs'] ?? {})['title'] ?? 'Job'}',
          timestamp: a['created_at'] != null
              ? DateTime.tryParse(a['created_at'].toString()) ?? DateTime.now()
              : DateTime.now(),
        );
      }).toList();

      // 6. Final Dashboard Stats Object
      dashboardStats = DashboardStats(
        totalApplications: totalApps,
        activeApplications: activeApps,
        interviewsScheduled: interviews,
        offersReceived: offers,
        profileViews: pViewsCount,
        applicationsByStatus: byStatus,
        recentActivities: recentActs,
      );

      // 7. Stats for the Home UI tiles
      stats = [
        HomeStatModel(
          label: 'Applications',
          count: totalApps,
          badge: 'Total applied',
          iconAsset: 'applications',
        ),
        HomeStatModel(
          label: 'Interviews',
          count: interviews,
          badge: 'Scheduled',
          iconAsset: 'interviews',
        ),
        HomeStatModel(
          label: 'Saved Jobs',
          count: savedJobsCount,
          badge: 'Bookmarked',
          iconAsset: 'saved',
        ),
        HomeStatModel(
          label: 'Job Views',
          count: appliedJobViewsCount,
          badge: 'Of your applied jobs',
          iconAsset: 'jobs_views', // New icon asset name
        ),
        HomeStatModel(
          label: 'Profile Views',
          count: pViewsCount,
          badge: 'From recruiters',
          iconAsset: 'views',
        ),
      ];
    } catch (e, stack) {
      debugPrint('Error fetching jobseeker stats: $e\n$stack');
      error = 'Failed to load stats.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// UI logic (dialogs) should be handled by the View or a UI helper.
  Future<void> applyForJob(String jobId, String coverLetter) async {
    try {
      await _repository.applyForJob(jobId, coverLetter);
      // Optional: Refresh stats after applying
      fetchStats();
    } catch (e) {
      debugPrint('Error in applyForJob logic: $e');
      rethrow;
    }
  }

  void navigateToJobInsights(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    
    // For a JobSeeker, we'll show insights for their LATEST application
    // or a summary. For now, let's find the most recent job they applied to.
    try {
      final lastApp = await _repository.getApplications(user.id);
      if (lastApp.isNotEmpty) {
        final jobId = lastApp.first['job_id'];
        final jobTitle = lastApp.first['jobs']['title'];
        
        Navigator.pushNamed(
          context,
          RoutesName.jobInsights,
          arguments: {'jobId': jobId, 'jobTitle': jobTitle},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apply to jobs to see their view insights!')),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to job insights: $e');
    }
  }
}
