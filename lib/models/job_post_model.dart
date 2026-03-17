/// Model representing a posted job listing
class JobPost {
  final String id;
  final String title;
  final String postedDate;
  final int applicants;
  final int views;
  final JobStatus status;

  const JobPost({
    required this.id,
    required this.title,
    required this.postedDate,
    required this.applicants,
    required this.views,
    required this.status,
  });
}

enum JobStatus { active, paused, closed }

/// Model for applicant display in Dashboard
class RecentApplicant {
  final String name;
  final String role;
  final String avatarInitial;

  const RecentApplicant({
    required this.name,
    required this.role,
    required this.avatarInitial,
  });
}
