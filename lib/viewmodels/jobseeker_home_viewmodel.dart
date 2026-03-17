import 'package:flutter/material.dart';
import '../models/home_stats_model.dart';

class JobseekerHomeViewModel extends ChangeNotifier {
  final List<HomeStatModel> stats = const [
    HomeStatModel(label: 'Applications', count: 24, badge: '+3 this week', iconAsset: 'applications'),
    HomeStatModel(label: 'Interviews', count: 5, badge: '+1 today', iconAsset: 'interviews'),
    HomeStatModel(label: 'Saved Jobs', count: 18, badge: '2 new matches', iconAsset: 'saved'),
    HomeStatModel(label: 'Profile Views', count: 142, badge: '+28% this month', iconAsset: 'views'),
  ];

  final List<RecentApplicationModel> recentApplications = const [
    RecentApplicationModel(
      title: 'Senior React Developer',
      company: 'TechCorp',
      status: 'Interview',
      date: 'Feb 20, 2026',
    ),
    RecentApplicationModel(
      title: 'Product Designer',
      company: 'DesignHub',
      status: 'Under Review',
      date: 'Feb 18, 2026',
    ),
    RecentApplicationModel(
      title: 'Data Scientist',
      company: 'DataFlow',
      status: 'Applied',
      date: 'Feb 15, 2026',
    ),
  ];
}
