class CreateJobRequest {
  final String title;
  final String companyName;
  final String description;
  final String requirements;
  final String location;
  final String jobType;
  final List<String> skills;
  final String experience;
  final String? salaryMin;
  final String? salaryMax;
  final String? salaryCurrency;
  final DateTime? expiresAt;
  final String status;

  CreateJobRequest({
    required this.title,
    required this.companyName,
    required this.description,
    required this.requirements,
    required this.location,
    required this.jobType,
    required this.skills,
    required this.experience,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.expiresAt,
    this.status = 'active',
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'company_name': companyName,
    'status': status,
    'description': description,
    'requirements': requirements,
    'location': location,
    'job_type': jobType,
    'skills': skills,
    'experience': experience,
    if (salaryMin != null) 'salary_min': salaryMin,
    if (salaryMax != null) 'salary_max': salaryMax,
    if (salaryCurrency != null) 'salary_currency': salaryCurrency,
    if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
  };
}

