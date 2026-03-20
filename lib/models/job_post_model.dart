/// Model representing a posted job listing
class JobPost {
  final String id;
  final String title;
  final String? companyName;
  final String? location;
  final String? jobType;
  final String? experience;
  final String? salaryMin;
  final String? salaryMax;
  final String? salaryCurrency;
  final String? description;
  final String? requirements;
  final List<String> skills;
  final DateTime postedDate;
  final int applicants;
  final int views;
  final String status;

  const JobPost({
    required this.id,
    required this.title,
    this.companyName,
    this.location,
    this.jobType,
    this.experience,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.description,
    this.requirements,
    this.skills = const [],
    required this.postedDate,
    required this.applicants,
    required this.views,
    required this.status,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled',
      companyName: json['company_name'],
      location: json['location'],
      jobType: json['job_type'],
      experience: json['experience'],
      salaryMin: json['salary_min'],
      salaryMax: json['salary_max'],
      salaryCurrency: json['salary_currency'],
      description: json['description'],
      requirements: json['requirements'],
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      postedDate: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      applicants: json['applicants'] ?? 0,
      views: json['views'] ?? 0,
      status: json['status'] ?? 'active',
    );
  }
}

enum JobStatus { active, expired, draft }

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

  factory RecentApplicant.fromJson(Map<String, dynamic> json) {
    final fullName = json['full_name']?.toString() ?? json['name']?.toString() ?? 'Unknown';
    final role = json['job_title']?.toString() ?? json['role']?.toString() ?? '';
    return RecentApplicant(
      name: fullName,
      role: role,
      avatarInitial: fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
    );
  }
}
