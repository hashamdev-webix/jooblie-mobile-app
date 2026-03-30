class CompanyModel {
  final String name;
  final String location;
  final int openJobsCount;
  final String? about;
  final String? website;
  final String? industry;
  final String? companySize;

  const CompanyModel({
    required this.name,
    required this.location,
    required this.openJobsCount,
    this.about,
    this.website,
    this.industry,
    this.companySize,
  });
}
