import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_recommendation_model.dart';
import 'package:flutter/foundation.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<JobRecommendationModel> _favoriteJobs = [];
  bool _isLoading = false;
  String? _error;

  List<JobRecommendationModel> get favoriteJobs =>
      List.unmodifiable(_favoriteJobs);
  bool get isLoading => _isLoading;
  String? get error => _error;

  FavoritesViewModel() {
    fetchFavoriteJobs();
  }

  Future<void> fetchFavoriteJobs() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('saved_jobs')
          .select('*, jobs(*)')
          .eq('user_id', user.id);

      _favoriteJobs.clear();
      if (response != null) {
        for (var item in response as List<dynamic>) {
          if (item['jobs'] != null) {
            _favoriteJobs.add(JobRecommendationModel.fromJson(item['jobs']));
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching favorite jobs: $e");
      _error = "Failed to load favorites";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(JobRecommendationModel job) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final isExist = _favoriteJobs.any((j) => j.id == job.id);

    // Optimistic UI update
    if (isExist) {
      _favoriteJobs.removeWhere((j) => j.id == job.id);
    } else {
      _favoriteJobs.add(job);
    }
    notifyListeners();

    try {
      if (isExist) {
        // Remove from DB
        await Supabase.instance.client
            .from('saved_jobs')
            .delete()
            .eq('user_id', user.id)
            .eq('job_id', job.id);
      } else {
        // Add to DB
        await Supabase.instance.client.from('saved_jobs').insert({
          'user_id': user.id,
          'job_id': job.id,
        });
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
      // Rollback on error
      if (isExist) {
        _favoriteJobs.add(job);
      } else {
        _favoriteJobs.removeWhere((j) => j.id == job.id);
      }
      notifyListeners();
    }
  }

  bool isFavorite(String jobId) {
    return _favoriteJobs.any((job) => job.id == jobId);
  }
}
