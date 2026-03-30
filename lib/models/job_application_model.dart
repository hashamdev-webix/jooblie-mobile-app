import 'job_recommendation_model.dart';

class JobApplicationModel {
  final String id;
  final String jobId;
  final String title;
  final String company;
  final String location;
  final String date;
  final String status;
  final JobRecommendationModel? jobData;

  const JobApplicationModel({
    required this.id,
    required this.jobId,
    required this.title,
    required this.company,
    required this.location,
    required this.date,
    required this.status,
    this.jobData,
  });
}
