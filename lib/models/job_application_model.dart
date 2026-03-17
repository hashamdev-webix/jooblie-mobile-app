class JobApplicationModel {
  final String title;
  final String company;
  final String location;
  final String date;
  final String status; // 'Interview Scheduled', 'Under Review', 'Applied'

  const JobApplicationModel({
    required this.title,
    required this.company,
    required this.location,
    required this.date,
    required this.status,
  });
}
