import 'package:supabase_flutter/supabase_flutter.dart';

class RecruiterRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetches detailed view history for a specific job.
  Future<List<Map<String, dynamic>>> getDetailedJobViews(String jobId) async {
    try {
      final response = await _client
          .from('views')
          .select('*, profiles:viewer_id(full_name, avatar_url, role, company_name, location, industry)')
          .eq('job_id', jobId)
          .order('last_viewed_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Relationship join failed, falling back to manual fetch: $e');
      
      // Fallback: Fetch views first, then profiles separately
      final viewsResponse = await _client
          .from('views')
          .select('*')
          .eq('job_id', jobId)
          .order('last_viewed_at', ascending: false);
      
      final List<Map<String, dynamic>> views = List<Map<String, dynamic>>.from(viewsResponse);
      if (views.isEmpty) return [];

      // Get unique viewer IDs
      final viewerIds = views.map((v) => v['viewer_id'].toString()).toSet().toList();
      
      // Fetch profiles for these viewers
      final profilesResponse = await _client
          .from('profiles')
          .select('id, full_name, avatar_url, role, job_title, company_name, location, industry')
          .inFilter('id', viewerIds);
      
      final Map<String, dynamic> profilesMap = {
        for (var p in (profilesResponse as List)) p['id'].toString(): p
      };

      // Merge data
      for (var v in views) {
        v['profiles'] = profilesMap[v['viewer_id'].toString()];
      }

      return views;
    }
  }

  /// Fetches aggregated insights for a job (top industries, locations, roles).
  Future<Map<String, dynamic>> getJobViewInsights(String jobId) async {
    final views = await getDetailedJobViews(jobId);
    
    final industries = <String, int>{};
    final locations = <String, int>{};
    final roles = <String, int>{};

    for (var view in views) {
      final profile = view['profiles'] as Map<String, dynamic>? ?? {};
      
      final industry = (view['viewer_industry'] ?? profile['industry']) as String?;
      if (industry != null) industries[industry] = (industries[industry] ?? 0) + 1;

      final location = (view['viewer_location'] ?? profile['location']) as String?;
      if (location != null) locations[location] = (locations[location] ?? 0) + 1;

      final role = (view['viewer_role'] ?? profile['role'] ?? profile['job_title']) as String?;
      if (role != null) roles[role] = (roles[role] ?? 0) + 1;
    }

    return {
      'total_views': views.length,
      'industries': industries,
      'locations': locations,
      'roles': roles,
      'recent_views': views.take(10).toList(),
    };
  }
}
