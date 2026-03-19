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
}
