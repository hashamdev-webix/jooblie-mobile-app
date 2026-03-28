import 'package:supabase_flutter/supabase_flutter.dart';

class RecruiterRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetches detailed view history for a specific job or all jobs of the current recruiter.
  Future<List<Map<String, dynamic>>> getDetailedJobViews(String? jobId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      var query = _client
          .from('views')
          .select('*, profiles:viewer_id(full_name, avatar_url, role, company_name, location, industry)');

      if (jobId != null && jobId != 'all') {
        query = query.eq('job_id', jobId);
      } else {
        // Fetch all jobs for this recruiter to filter views
        final jobsResponse = await _client
            .from('jobs')
            .select('id')
            .eq('recruiter_id', userId);
        
        final List<String> recruiterJobIds = (jobsResponse as List)
            .map((j) => j['id'].toString())
            .toList();
            
        if (recruiterJobIds.isEmpty) return [];
        
        query = query.inFilter('job_id', recruiterJobIds);
      }

      final response = await query.order('last_viewed_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Relationship join failed, falling back to manual fetch: $e');
      
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      // Fallback: Fetch views first, then profiles separately
      var viewsQuery = _client
          .from('views')
          .select('*');

      if (jobId != null && jobId != 'all') {
        viewsQuery = viewsQuery.eq('job_id', jobId);
      } else {
        final jobsResponse = await _client
            .from('jobs')
            .select('id')
            .eq('recruiter_id', userId);
        
        final List<String> recruiterJobIds = (jobsResponse as List)
            .map((j) => j['id'].toString())
            .toList();
            
        if (recruiterJobIds.isEmpty) return [];
        
        viewsQuery = viewsQuery.inFilter('job_id', recruiterJobIds);
      }
      
      final viewsResponse = await viewsQuery.order('last_viewed_at', ascending: false);
      
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
