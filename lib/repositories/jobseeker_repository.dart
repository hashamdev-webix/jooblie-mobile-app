import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/apply_job_request.dart';
import '../services/api_service.dart';

class JobseekerRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final ApiService _apiService = ApiService();

  /// Fetches the full name of the job seeker.
  Future<String?> getProfileName(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .maybeSingle();
      return response?['full_name']?.toString();
    } catch (e) {
      debugPrint('Error fetching profile name: $e');
      return null;
    }
  }

  /// Fetches all applications for the job seeker, including job details.
  Future<List<Map<String, dynamic>>> getApplications(String userId) async {
    try {
      final response = await _client
          .from('applications')
          .select('*, jobs!inner(*)')
          .eq('applicant_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching applications: $e');
      return [];
    }
  }

  /// Fetches the total number of profile views for the job seeker.
  /// Fetches total views for all jobs the user has applied to.
  Future<int> getAppliedJobViewsCount(String userId) async {
    try {
      // 1. Get IDs of jobs the user applied to
      final apps = await _client
          .from('applications')
          .select('job_id')
          .eq('applicant_id', userId);
      
      final jobIds = (apps as List).map((a) => a['job_id'].toString()).toList();
      if (jobIds.isEmpty) return 0;

      // 2. Count total views for these jobs
      final viewsResponse = await _client
          .from('views')
          .select('id')
          .inFilter('job_id', jobIds);
      
      return (viewsResponse as List).length;
    } catch (e) {
      print('Error fetching applied job views: $e');
      return 0;
    }
  }

  Future<int> getProfileViewsCount(String userId) async {
    try {
      final response = await _client
          .from('views')
          .select('id')
          .eq('profile_id', userId);
      return (response as List).length;
    } catch (e) {
      debugPrint('Error fetching profile views count: $e');
      return 0;
    }
  }

  /// Fetches detailed profile views with metadata snapshot.
  Future<List<Map<String, dynamic>>> getDetailedProfileViews(String userId) async {
    try {
      final response = await _client
          .from('views')
          .select('*')
          .eq('profile_id', userId)
          .order('last_viewed_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching detailed profile views: $e');
      return [];
    }
  }

  /// Fetches the total number of saved jobs for the job seeker.
  Future<int> getSavedJobsCount(String userId) async {
    try {
      final response = await _client
          .from('saved_jobs')
          .select('id')
          .eq('user_id', userId);
      return (response as List).length;
    } catch (e) {
      debugPrint('Error fetching saved jobs count: $e');
      return 0;
    }
  }

  /// Submits a job application.
  Future<void> applyForJob(String jobId, String coverLetter) async {
    final request = ApplyJobRequest(coverLetter: coverLetter);
    await _apiService.applyForJob(jobId, request);
  }
}
