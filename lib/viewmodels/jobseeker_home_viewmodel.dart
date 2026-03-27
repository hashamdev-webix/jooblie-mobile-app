import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/home_stats_model.dart';
import '../models/dashboard_stats_model.dart';

class JobseekerHomeViewModel extends ChangeNotifier {
  bool isLoading = false;
  String userName = '';
  String? error;
  DashboardStats? dashboardStats;

  List<HomeStatModel> stats = [
    const HomeStatModel(label: 'Applications', count: 0, badge: 'Total applied', iconAsset: 'applications'),
    const HomeStatModel(label: 'Interviews', count: 0, badge: 'Scheduled', iconAsset: 'interviews'),
    const HomeStatModel(label: 'Saved Jobs', count: 0, badge: 'Bookmarked', iconAsset: 'saved'),
    const HomeStatModel(label: 'Profile Views', count: 0, badge: 'From recruiters', iconAsset: 'views'),
  ];

  List<RecentApplicationModel> recentApplications = [];

  JobseekerHomeViewModel() {
    fetchStats();
  }

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

      // Fetch all applications for the job seeker
      final applicationsResponse = await Supabase.instance.client
          .from('applications')
          .select('*, jobs!inner(*)')
          .eq('applicant_id', user.id);

      final List<dynamic> allApps = applicationsResponse as List<dynamic>;

      int totalApps = allApps.length;
      int activeApps = allApps.where((app) => app['status'] != 'Rejected' && app['status'] != 'Archived').length;
      int interviews = allApps.where((app) => app['status'] == 'Interview').length;
      int offers = allApps.where((app) => app['status'] == 'Offer').length;

      // Profile views from views table
      int pViewsCount = 0;
      try {
        final profileViewsResponse = await Supabase.instance.client
            .from('views')
            .select('id')
            .eq('profile_id', user.id);
        pViewsCount = (profileViewsResponse as List).length;
      } catch (_) {}

      // Fetch user name from profiles table
      try {
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('full_name')
            .eq('id', user.id)
            .maybeSingle();
        if (profile != null) {
          final name = profile['full_name']?.toString() ?? '';
          if (name.isNotEmpty) {
            userName = name.split(' ').first;
          } else {
            userName = user.userMetadata?['full_name']?.toString().split(' ').first ?? 'there';
          }
        }
      } catch (_) {
        userName = user.userMetadata?['full_name']?.toString().split(' ').first ?? 'there';
      }

      // Saved Jobs count
      int savedJobsCount = 0;
      try {
        final savedJobsResponse = await Supabase.instance.client
            .from('saved_jobs')
            .select('id')
            .eq('user_id', user.id);
        savedJobsCount = (savedJobsResponse as List).length;
      } catch (_) {}

      // Calculate applicationsByStatus
      final Map<String, int> statusCounts = {};
      for (var app in allApps) {
        final st = app['status']?.toString() ?? 'Pending';
        statusCounts[st] = (statusCounts[st] ?? 0) + 1;
      }
      final List<ApplicationStatusCount> byStatus = statusCounts.entries
          .map((e) => ApplicationStatusCount(status: e.key, count: e.value))
          .toList();

      // Sort recent applications
      allApps.sort((a, b) {
        final d1 = a['created_at'] != null ? DateTime.parse(a['created_at']) : DateTime.now();
        final d2 = b['created_at'] != null ? DateTime.parse(b['created_at']) : DateTime.now();
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
          } catch (_) {
            formattedDate = json['created_at'].toString().split('T')[0];
          }
        }
        return RecentApplicationModel(
          title: job['title']?.toString() ?? 'Unknown Role',
          company: job['company_name']?.toString() ?? 'Unknown Company',
          status: json['status']?.toString() ?? 'Applied',
          date: formattedDate,
        );
      }).toList();

      final recentActs = topApps.map((a) {
        return RecentActivity(
          type: 'application',
          description: 'Applied for ${(a['jobs'] ?? {})['title'] ?? 'Job'}',
          timestamp: a['created_at'] != null ? DateTime.tryParse(a['created_at'].toString()) ?? DateTime.now() : DateTime.now(),
        );
      }).toList();

      dashboardStats = DashboardStats(
        totalApplications: totalApps,
        activeApplications: activeApps,
        interviewsScheduled: interviews,
        offersReceived: offers,
        profileViews: pViewsCount,
        applicationsByStatus: byStatus,
        recentActivities: recentActs,
      );

      stats = [
        HomeStatModel(label: 'Applications', count: totalApps, badge: 'Total applied', iconAsset: 'applications'),
        HomeStatModel(label: 'Interviews', count: interviews, badge: 'Scheduled', iconAsset: 'interviews'),
        HomeStatModel(label: 'Saved Jobs', count: savedJobsCount, badge: 'Bookmarked', iconAsset: 'saved'),
        HomeStatModel(label: 'Profile Views', count: pViewsCount, badge: 'From recruiters', iconAsset: 'views'),
      ];

    } catch (e, stack) {
      debugPrint('Error fetching jobseeker stats: $e\n$stack');
      error = 'Failed to load stats.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
