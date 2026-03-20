class JobRecommendationModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salaryRange;
  final int matchPercent;
  final String postedTime;
  final String jobType;
  final List<String> tags;
  final String description;
  final List<String> requirements;
  final List<String> benefits;

  const JobRecommendationModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryRange,
    required this.matchPercent,
    required this.postedTime,
    required this.jobType,
    required this.tags,
    required this.description,
    required this.requirements,
    required this.benefits,
  });

  factory JobRecommendationModel.fromJson(Map<String, dynamic> json) {
    // Build salary range string from min/max fields
    final salaryMin = json['salary_min']?.toString();
    final salaryMax = json['salary_max']?.toString();
    final currency = json['salary_currency'] ?? 'USD';
    String salaryRange = 'Not specified';
    if (salaryMin != null && salaryMax != null) {
      salaryRange = '$currency $salaryMin - $salaryMax';
    } else if (salaryMin != null) {
      salaryRange = '$currency $salaryMin+';
    } else if (salaryMax != null) {
      salaryRange = 'Up to $currency $salaryMax';
    }

    // Compute human-readable posted time
    String postedTime = 'Recently';
    final createdAt = json['created_at'];
    if (createdAt != null) {
      final dt = DateTime.tryParse(createdAt.toString());
      if (dt != null) {
        final diff = DateTime.now().difference(dt);
        if (diff.inDays >= 1) {
          postedTime = '${diff.inDays}d ago';
        } else if (diff.inHours >= 1) {
          postedTime = '${diff.inHours}h ago';
        } else {
          postedTime = 'Just now';
        }
      }
    }

    // Parse skills as tags
    final rawSkills = json['skills'];
    List<String> tags = [];
    if (rawSkills is List) {
      tags = rawSkills.map((s) => s.toString()).toList();
    }

    // Parse requirements
    final rawReq = json['requirements'];
    List<String> requirements = [];
    if (rawReq is List) {
      requirements = rawReq.map((r) => r.toString()).toList();
    } else if (rawReq is String && rawReq.isNotEmpty) {
      requirements = rawReq.split('\n').where((s) => s.isNotEmpty).toList();
    }

    return JobRecommendationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      company: json['company_name'] ?? '',
      location: json['location'] ?? '',
      salaryRange: salaryRange,
      matchPercent: 0, // Not computed server-side in this flow
      postedTime: postedTime,
      jobType: json['job_type'] ?? '',
      tags: tags,
      description: json['description'] ?? '',
      requirements: requirements,
      benefits: const [],
    );
  }
}

