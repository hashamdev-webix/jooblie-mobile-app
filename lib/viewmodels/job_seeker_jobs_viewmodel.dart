import 'package:flutter/material.dart';
import '../models/job_recommendation_model.dart';

class JobSeekerJobsViewModel extends ChangeNotifier {
  final List<JobRecommendationModel> _jobs = [
    JobRecommendationModel(
      title: 'Senior React Developer',
      company: 'TechCorp',
      location: 'Remote',
      salaryRange: '\$120K - \$160K',
      postedTime: '2 days ago',
      jobType: 'Full-time',
      description: 'We are looking for a Senior React Developer to join our team...',
      requirements: ['5+ years experience', 'Strong React skills', 'TypeScript knowledge'],
      benefits: ['Remote work', 'Competitive salary', 'Health insurance'],
      tags: ['React', 'TypeScript', 'Node.js'],
      matchPercent: 95,
    ),
     JobRecommendationModel(
      title: 'Product Designer',
      company: 'DesignHub',
      location: 'New York, NY',
      salaryRange: '\$100K - \$140K',
      postedTime: '1 day ago',
      jobType: 'Full-time',
      description: 'DesignHub is seeking a creative Product Designer...',
      requirements: ['3+ years experience', 'Figma expert', 'UI/UX focus'],
      benefits: ['Flexible hours', 'Modern office', 'Equity options'],
      tags: ['Figma', 'UI/UX', 'Prototyping'],
      matchPercent: 88,
    ),
     JobRecommendationModel(
      title: 'Flutter Developer',
      company: 'AppWorks',
      location: 'Lahore',
      salaryRange: '\$80K - \$120K',
      postedTime: '3 days ago',
      jobType: 'Full-time',
      description: 'Join our mobile team to build stunning apps with Flutter...',
      requirements: ['2+ years Flutter experience', 'Dart proficiency', 'REST API integration'],
      benefits: ['Health insurance', 'Paid time off', 'Bonus system'],
      tags: ['Flutter', 'Dart', 'Provider'],
      matchPercent: 92,
    ),
  ];

  List<JobRecommendationModel> get jobs => _jobs;

  // Add search and filter logic here if needed later
}
