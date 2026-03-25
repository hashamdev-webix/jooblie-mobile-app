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
  final String applicationId; // applications.id
  final String applicantId; // profiles.id
  final String name;
  final String role; // Current job seeker role/title
  final String avatarInitial;
  final String? jobTitle; // Title of the job they applied for
  final String? status; // Application status (Pending, etc.)
  final String? resumeUrl;

  const RecentApplicant({
    required this.applicationId,
    required this.applicantId,
    required this.name,
    required this.role,
    required this.avatarInitial,
    this.jobTitle,
    this.status,
    this.resumeUrl,
  });

  factory RecentApplicant.fromJson(Map<String, dynamic> json) {
    // 1. Check for profile data at top level (denormalized) OR in joined object
    final String fullName = json['full_name']?.toString() ?? 
                            json['profiles']?['full_name']?.toString() ?? 
                            json['profiles']?['name']?.toString() ?? 
                            'Unknown Applicant';
                            
    final String role = json['job_title']?.toString() ?? 
                        json['profiles']?['job_title']?.toString() ?? 
                        json['profiles']?['role']?.toString() ?? 
                        'Job Seeker';

    // Defensive check for jobs
    Map<String, dynamic> job = {};
    if (json['jobs'] is Map) {
      job = json['jobs'] as Map<String, dynamic>;
    } else if (json['jobs'] is List && (json['jobs'] as List).isNotEmpty) {
      job = (json['jobs'] as List).first as Map<String, dynamic>;
    }

    final String? appliedJob = job['title']?.toString();
    final String? appStatus = json['status']?.toString();
    final String? resume = json['resume_url']?.toString();

    return RecentApplicant(
      applicationId: json['id']?.toString() ?? '',
      applicantId: json['applicant_id']?.toString() ?? 
                   json['profiles']?['id']?.toString() ?? '',
      name: fullName,
      role: role,
      avatarInitial: fullName.isNotEmpty && fullName != 'Unknown Applicant' 
          ? fullName[0].toUpperCase() : '?',
      jobTitle: appliedJob,
      status: appStatus ?? 'Pending',
      resumeUrl: resume,
    );
  }
}

class ApplicationDetail {
  final String applicationId;
  final String applicantId;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String location;
  final String about;
  final List<String> skills;
  final String jobTitle; // Job applied for
  final String? status;
  final String? resumeUrl;
  final String? coverLetter;

  const ApplicationDetail({
    required this.applicationId,
    required this.applicantId,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.location,
    required this.about,
    required this.skills,
    required this.jobTitle,
    this.status,
    this.resumeUrl,
    this.coverLetter,
  });

  factory ApplicationDetail.fromJson(Map<String, dynamic> json) {
    // Defensive check for profiles
    Map<String, dynamic> profile = {};
    if (json['profiles'] is Map) {
      profile = json['profiles'] as Map<String, dynamic>;
    } else if (json['profiles'] is List && (json['profiles'] as List).isNotEmpty) {
      profile = (json['profiles'] as List).first as Map<String, dynamic>;
    }

    // Defensive check for jobs
    Map<String, dynamic> job = {};
    if (json['jobs'] is Map) {
      job = json['jobs'] as Map<String, dynamic>;
    } else if (json['jobs'] is List && (json['jobs'] as List).isNotEmpty) {
      job = (json['jobs'] as List).first as Map<String, dynamic>;
    }

    // Robust skills parsing (handle List or comma-separated String)
    List<String> skillsList = [];
    final rawSkills = profile['skills'];
    if (rawSkills is List) {
      skillsList = rawSkills.map((s) => s.toString()).toList();
    } else if (rawSkills is String && rawSkills.isNotEmpty) {
      skillsList = rawSkills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }

    return ApplicationDetail(
      applicationId: json['id']?.toString() ?? '',
      applicantId: json['applicant_id']?.toString() ?? profile['id']?.toString() ?? '',
      name: profile['full_name']?.toString() ?? profile['name']?.toString() ?? 'Unknown',
      email: profile['email']?.toString() ?? '',
      role: profile['job_title']?.toString() ?? profile['role']?.toString() ?? 'Job Seeker',
      avatarUrl: profile['avatar_url']?.toString(),
      location: profile['location']?.toString() ?? 'Unknown',
      about: profile['about']?.toString() ?? '',
      skills: skillsList,
      jobTitle: job['title']?.toString() ?? 'Unknown Job',
      status: json['status']?.toString() ?? 'Pending',
      resumeUrl: json['resume_url']?.toString(),
      coverLetter: json['cover_letter']?.toString(),
    );
  }
}
