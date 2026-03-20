class JobFilters {
  final String? search;
  final String? location;
  final String? jobType;
  final String? experience;
  final int? minSalary;
  final int? maxSalary;
  final List<String>? skills;
  final int page;
  final int limit;
  final String? sortBy;
  final String? order;

  const JobFilters({
    this.search,
    this.location,
    this.jobType,
    this.experience,
    this.minSalary,
    this.maxSalary,
    this.skills,
    this.page = 1,
    this.limit = 20,
    this.sortBy = 'created_at',
    this.order = 'desc',
  });

  JobFilters copyWith({
    String? search,
    String? location,
    String? jobType,
    String? experience,
    int? minSalary,
    int? maxSalary,
    List<String>? skills,
    int? page,
    int? limit,
    String? sortBy,
    String? order,
  }) {
    return JobFilters(
      search: search ?? this.search,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      experience: experience ?? this.experience,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      skills: skills ?? this.skills,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  /// Clear all filters (reset to defaults, page 1)
  JobFilters reset() => const JobFilters();

  String toQueryString() {
    final params = <String, String>{};
    if (search != null && search!.isNotEmpty) params['search'] = search!;
    if (location != null && location!.isNotEmpty) params['location'] = location!;
    if (jobType != null && jobType!.isNotEmpty) params['job_type'] = jobType!;
    if (experience != null && experience!.isNotEmpty) params['experience'] = experience!;
    if (minSalary != null) params['min_salary'] = minSalary.toString();
    if (maxSalary != null) params['max_salary'] = maxSalary.toString();
    if (skills != null && skills!.isNotEmpty) params['skills'] = skills!.join(',');
    params['page'] = page.toString();
    params['limit'] = limit.toString();
    if (sortBy != null) params['sort_by'] = sortBy!;
    if (order != null) params['order'] = order!;
    return params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
  }

  bool get hasActiveFilters =>
      search != null ||
      location != null ||
      jobType != null ||
      experience != null ||
      minSalary != null ||
      maxSalary != null ||
      (skills != null && skills!.isNotEmpty);
}
