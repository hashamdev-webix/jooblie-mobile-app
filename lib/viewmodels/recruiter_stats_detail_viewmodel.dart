import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_post_model.dart';
import '../services/views_service.dart';

class RecruiterStatsDetailViewModel extends ChangeNotifier {
  List<JobPost> activeJobs = [];
  bool isLoadingJobs = false;

  List<RecentApplicant> allApplicants = [];
  bool isLoadingApplicants = false;

  Future<void> fetchActiveJobs() async {
    isLoadingJobs = true;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        isLoadingJobs = false;
        notifyListeners();
        return;
      }

      final response = await Supabase.instance.client
          .from('jobs')
          .select()
          .eq('recruiter_id', userId)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      final List<String> jobIds = data.map((j) => j['id'].toString()).toList();

      if (jobIds.isNotEmpty) {
        final results = await Future.wait([
          ViewsService.getJobViews(jobIds),
          ViewsService.getJobApplicants(jobIds),
        ]);

        final jobViewCounts = results[0] as Map<String, int>;
        final jobAppCounts = results[1] as Map<String, int>;

        for (var json in data) {
          final jobId = json['id'].toString();
          if (jobViewCounts.containsKey(jobId)) {
            json['views'] = jobViewCounts[jobId];
          }
          if (jobAppCounts.containsKey(jobId)) {
            json['applicants'] = jobAppCounts[jobId];
          }
        }
      }

      activeJobs = data.map((json) => JobPost.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching active jobs for stats view: $e');
    } finally {
      isLoadingJobs = false;
      notifyListeners();
    }
  }

  Future<void> fetchTotalApplicants() async {
    isLoadingApplicants = true;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        isLoadingApplicants = false;
        notifyListeners();
        return;
      }

      final applicantsResponse = await Supabase.instance.client
          .from('applications')
          .select('*, jobs!inner(title, recruiter_id), profiles:applicant_id(*)')
          .eq('jobs.recruiter_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> appList = applicantsResponse as List<dynamic>;
      allApplicants = appList.map((a) {
        try {
          final data = Map<String, dynamic>.from(a as Map);

          final String? resUrl = data['resume_url']?.toString();
          if (resUrl != null && !resUrl.startsWith('http')) {
            final String path = resUrl.startsWith('resumes/')
                ? resUrl.replaceFirst('resumes/', '')
                : resUrl;
            data['resume_url'] = Supabase.instance.client.storage
                .from('resumes')
                .getPublicUrl(path);
          }

          return RecentApplicant.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing applicant: $e');
          return null;
        }
      }).whereType<RecentApplicant>().toList();
    } catch (e) {
      debugPrint('Error fetching total applicants for stats view: $e');
      allApplicants = [];
    } finally {
      isLoadingApplicants = false;
      notifyListeners();
    }
  }
}
