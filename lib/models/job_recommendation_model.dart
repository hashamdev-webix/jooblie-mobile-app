class JobRecommendationModel {
  final String title;
  final String company;
  final String location;
  final String salaryRange;
  final int matchPercent;

  const JobRecommendationModel({
    required this.title,
    required this.company,
    required this.location,
    required this.salaryRange,
    required this.matchPercent,
  });
}
