import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewsService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Records a unique view for a job by the current user.
  static Future<void> recordJobView(String jobId) async {
    try {
      final viewerId = _client.auth.currentUser?.id;
      if (viewerId == null) return;

      final existingView = await _client
          .from('views')
          .select('id')
          .eq('job_id', jobId)
          .eq('viewer_id', viewerId)
          .maybeSingle();

      if (existingView == null) {
        await _client.from('views').insert({
          'job_id': jobId,
          'viewer_id': viewerId,
        });
        debugPrint('Job view recorded: job=$jobId, viewer=$viewerId');
      }
    } catch (e) {
      debugPrint('Error recording job view: $e');
    }
  }

  /// Records a unique view for a profile by the current user.
  static Future<void> recordProfileView(String profileId) async {
    try {
      final viewerId = _client.auth.currentUser?.id;
      if (viewerId == null) return;

      if (viewerId == profileId) return;

      final existingView = await _client
          .from('views')
          .select('id')
          .eq('profile_id', profileId)
          .eq('viewer_id', viewerId)
          .maybeSingle();

      if (existingView == null) {
        await _client.from('views').insert({
          'profile_id': profileId,
          'viewer_id': viewerId,
        });
        debugPrint(
          'Profile view recorded: profile=$profileId, viewer=$viewerId',
        );
      }
    } catch (e) {
      debugPrint('Error recording profile view: $e');
    }
  }

  /// Fetches unique view counts for a list of job IDs.
  /// Returns a map of jobId to unique view count.
  static Future<Map<String, int>> getJobViews(List<String> jobIds) async {
    if (jobIds.isEmpty) return {};

    try {
      final response = await _client
          .from('views')
          .select('job_id, viewer_id')
          .inFilter('job_id', jobIds);

      final List<dynamic> allViews = response as List<dynamic>;
      final Map<String, int> counts = {};

      for (var jobId in jobIds) {
        final uniqueViewers = allViews
            .where((v) => v['job_id'].toString() == jobId)
            .map((v) => v['viewer_id'])
            .toSet();
        counts[jobId] = uniqueViewers.length;
      }
      return counts;
    } catch (e) {
      debugPrint('Error fetching job views: $e');
      return {};
    }
  }

  /// Fetches applicant counts for a list of job IDs.
  static Future<Map<String, int>> getJobApplicants(List<String> jobIds) async {
    if (jobIds.isEmpty) return {};

    try {
      final response = await _client
          .from('applications')
          .select('job_id')
          .inFilter('job_id', jobIds);

      final List<dynamic> allApps = response as List<dynamic>;
      final Map<String, int> counts = {};

      for (var jobId in jobIds) {
        counts[jobId] = allApps
            .where((a) => a['job_id'].toString() == jobId)
            .length;
      }
      return counts;
    } catch (e) {
      debugPrint('Error fetching job applicant counts: $e');
      return {};
    }
  }
}
