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
