import 'package:flutter/material.dart';
import '../models/job_recommendation_model.dart';

class JobseekerRecommendationsViewModel extends ChangeNotifier {
  final List<JobRecommendationModel> recommendations = const [
    JobRecommendationModel(
      title: 'Senior React Developer',
      company: 'TechCorp',
      location: 'Remote',
      salaryRange: '\$120K–\$160K',
      matchPercent: 95,
    ),
    JobRecommendationModel(
      title: 'Full Stack Engineer',
      company: 'DataFlow',
      location: 'Austin, TX',
      salaryRange: '\$115K–\$155K',
      matchPercent: 90,
    ),
    JobRecommendationModel(
      title: 'Frontend Architect',
      company: 'CloudNine',
      location: 'Remote',
      salaryRange: '\$140K–\$180K',
      matchPercent: 87,
    ),
    JobRecommendationModel(
      title: 'Product Designer',
      company: 'DesignHub',
      location: 'New York',
      salaryRange: '\$90K–\$120K',
      matchPercent: 82,
    ),
    JobRecommendationModel(
      title: 'Flutter Developer',
      company: 'MobileFirst',
      location: 'Remote',
      salaryRange: '\$100K–\$140K',
      matchPercent: 78,
    ),
  ];
}
