import 'package:flutter/material.dart';
import '../models/job_application_model.dart';

class JobseekerApplicationsViewModel extends ChangeNotifier {
  final List<JobApplicationModel> applications = const [
    JobApplicationModel(
      title: 'Senior React Developer',
      company: 'TechCorp',
      location: 'Remote',
      date: 'Feb 15, 2026',
      status: 'Interview Scheduled',
    ),
    JobApplicationModel(
      title: 'Product Designer',
      company: 'DesignHub',
      location: 'New York',
      date: 'Feb 14, 2026',
      status: 'Under Review',
    ),
    JobApplicationModel(
      title: 'Data Scientist',
      company: 'DataFlow',
      location: 'Austin, TX',
      date: 'Feb 12, 2026',
      status: 'Applied',
    ),
    JobApplicationModel(
      title: 'Flutter Developer',
      company: 'MobileCo',
      location: 'San Francisco',
      date: 'Feb 10, 2026',
      status: 'Applied',
    ),
    JobApplicationModel(
      title: 'Backend Engineer',
      company: 'CloudBase',
      location: 'Remote',
      date: 'Feb 8, 2026',
      status: 'Under Review',
    ),
  ];
}
