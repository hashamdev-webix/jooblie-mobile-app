import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewsService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<void> recordJobView(String jobId) async {
    try {
      final viewerId = _client.auth.currentUser?.id;
      if (viewerId == null) return;

      final viewerProfile = await _client
          .from('profiles')
          .select('full_name, role, company_name, location, industry, is_private_mode')
          .eq('id', viewerId)
          .single();

      final bool isPrivateMode = viewerProfile['is_private_mode'] ?? false;

      final response = await _client
          .from('views')
          .select('id, last_viewed_at')
          .eq('job_id', jobId)
          .eq('viewer_id', viewerId)
          .order('last_viewed_at', ascending: false)
          .limit(1);

      final List<dynamic> data = response as List<dynamic>;
      bool shouldUpdate = false;
      String? existingId;

      final nowUtc = DateTime.now().toUtc();

      if (data.isNotEmpty) {
        final lastViewedStr = data.first['last_viewed_at'];
        if (lastViewedStr != null) {
          final lastViewed = DateTime.parse(lastViewedStr).toUtc();
          final diff = nowUtc.difference(lastViewed);
          if (diff.inHours < 24) {
            shouldUpdate = true;
            existingId = data.first['id'].toString();
            debugPrint('🕒 [ViewsService] Found existing JOB view (ID: $existingId) from ${diff.inHours}h ago. Updating it.');
          }
        }
      }

      if (shouldUpdate && existingId != null) {
        await _client.from('views').update({
          'last_viewed_at': nowUtc.toIso8601String(),
        }).eq('id', existingId);
        debugPrint('✅ [ViewsService] Job view updated (24h window): job=$jobId');
      } else {
        await _client.from('views').insert({
          'job_id': jobId,
          'viewer_id': viewerId,
          'viewer_name': isPrivateMode ? null : viewerProfile['full_name'],
          'viewer_role': viewerProfile['job_title'] ?? viewerProfile['role'],
          'viewer_company': viewerProfile['company_name'],
          'viewer_location': viewerProfile['location'],
          'viewer_industry': viewerProfile['industry'],
          'viewer_is_anonymous': isPrivateMode,
          'created_at': nowUtc.toIso8601String(),
          'last_viewed_at': nowUtc.toIso8601String(),
        });
        debugPrint('🆕 [ViewsService] INSERTED new JOB view for job: $jobId');
      }
    } catch (e) {
      debugPrint('Error recording job view: $e');
    }
  }

  static Future<void> recordProfileView(String profileId, {String? applicationId}) async {
    try {
      final viewerId = _client.auth.currentUser?.id;
      if (viewerId == null || viewerId == profileId) return;

      final viewerProfile = await _client
          .from('profiles')
          .select('full_name, role, company_name, location, industry, is_private_mode')
          .eq('id', viewerId)
          .single();

      final bool isPrivateMode = viewerProfile['is_private_mode'] ?? false;

      var query = _client
          .from('views')
          .select('id, last_viewed_at')
          .eq('profile_id', profileId)
          .eq('viewer_id', viewerId)
          .filter('job_id', 'is', null);

      if (applicationId != null) {
        query = query.eq('application_id', applicationId);
      }

      final response = await query
          .order('last_viewed_at', ascending: false)
          .limit(1);

      final List<dynamic> data = response as List<dynamic>;
      bool shouldUpdate = false;
      String? existingId;

      final nowUtc = DateTime.now().toUtc();

      if (data.isNotEmpty) {
        final lastViewedStr = data.first['last_viewed_at'];
        if (lastViewedStr != null) {
          final lastViewed = DateTime.parse(lastViewedStr).toUtc();
          final diff = nowUtc.difference(lastViewed);
          
          if (diff.inHours < 24) {
            shouldUpdate = true;
            existingId = data.first['id'].toString();
            debugPrint('🕒 [ViewsService] Found existing view (ID: $existingId) from ${diff.inHours}h ago. Updating it.');
          }
        }
      }

      if (shouldUpdate && existingId != null) {
        await _client.from('views').update({
          'last_viewed_at': nowUtc.toIso8601String(),
        }).eq('id', existingId);
        debugPrint('✅ [ViewsService] Profile view updated (24h window): profile=$profileId, app=$applicationId');
      } else {
        await _client.from('views').insert({
          'profile_id': profileId,
          'viewer_id': viewerId,
          'application_id': applicationId,
          'viewer_name': isPrivateMode ? null : viewerProfile['full_name'],
          'viewer_role': viewerProfile['job_title'] ?? viewerProfile['role'],
          'viewer_company': viewerProfile['company_name'],
          'viewer_location': viewerProfile['location'],
          'viewer_industry': viewerProfile['industry'],
          'viewer_is_anonymous': isPrivateMode,
          'created_at': nowUtc.toIso8601String(),
          'last_viewed_at': nowUtc.toIso8601String(),
        });
        debugPrint('🆕 [ViewsService] INSERTED new profile view for profile: $profileId, app=$applicationId');
      }
    } catch (e) {
      debugPrint('Error recording profile view: $e');
    }
  }

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
