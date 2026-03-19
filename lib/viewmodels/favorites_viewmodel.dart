import 'package:flutter/material.dart';
import '../models/job_recommendation_model.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<JobRecommendationModel> _favoriteJobs = [];

  List<JobRecommendationModel> get favoriteJobs => List.unmodifiable(_favoriteJobs);

  void toggleFavorite(JobRecommendationModel job) {
    final isExist = _favoriteJobs.any((j) => j.id == job.id);
    if (isExist) {
      _favoriteJobs.removeWhere((j) => j.id == job.id);
    } else {
      _favoriteJobs.add(job);
    }
    notifyListeners();
  }

  bool isFavorite(String jobId) {
    return _favoriteJobs.any((job) => job.id == jobId);
  }
}
