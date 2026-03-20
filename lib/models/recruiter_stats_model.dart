import '../models/job_post_model.dart';

class JobPerformance {
  final String id;
  final String title;
  final int applicants;
  final int views;

  const JobPerformance({
    required this.id,
    required this.title,
    required this.applicants,
    required this.views,
  });

  factory JobPerformance.fromJson(Map<String, dynamic> json) {
    return JobPerformance(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      applicants: json['applicants'] ?? 0,
      views: json['views'] ?? 0,
    );
  }
}

class RecruiterStats {
  final int activeJobs;
  final int totalApplicants;
  final int jobViews;
  final double hireRate;
  final List<JobPerformance> topJobs;
  final List<RecentApplicant> recentApplicants;

  const RecruiterStats({
    required this.activeJobs,
    required this.totalApplicants,
    required this.jobViews,
    required this.hireRate,
    required this.topJobs,
    required this.recentApplicants,
  });

  factory RecruiterStats.fromJson(Map<String, dynamic> json) {
    return RecruiterStats(
      activeJobs: json['active_jobs'] ?? 0,
      totalApplicants: json['total_applicants'] ?? 0,
      jobViews: json['job_views'] ?? 0,
      hireRate: (json['hire_rate'] ?? 0).toDouble(),
      topJobs: (json['top_jobs'] as List<dynamic>? ?? [])
          .map((j) => JobPerformance.fromJson(j))
          .toList(),
      recentApplicants: (json['recent_applicants'] as List<dynamic>? ?? [])
          .map((a) => RecentApplicant.fromJson(a))
          .toList(),
    );
  }
}
