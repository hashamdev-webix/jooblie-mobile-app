import 'package:flutter/material.dart';
import '../models/job_post_model.dart';

class RecruiterDashboardViewModel extends ChangeNotifier {
  // --- Stat Cards Data ---
  final int activeJobs = 8;
  final String activeJobsChange = '+2 this month';
  final int totalApplicants = 246;
  final String totalApplicantsChange = '+34 this week';
  final String jobViews = '1.2K';
  final String jobViewsChange = '+18% this month';
  final String hireRate = '24%';
  final String hireRateChange = '+5% improvement';

  // --- Recent Applicants ---
  final List<RecentApplicant> recentApplicants = const [
    RecentApplicant(
      name: 'Alice Johnson',
      role: 'Senior React Developer',
      avatarInitial: 'A',
    ),
    RecentApplicant(
      name: 'Mark Stevens',
      role: 'Product Designer',
      avatarInitial: 'M',
    ),
    RecentApplicant(
      name: 'Sara Lin',
      role: 'Data Scientist',
      avatarInitial: 'S',
    ),
    RecentApplicant(
      name: 'James Park',
      role: 'Backend Engineer',
      avatarInitial: 'J',
    ),
  ];
}

class RecruiterJobsViewModel extends ChangeNotifier {
  final List<JobPost> jobs = const [
    JobPost(
      id: '1',
      title: 'Senior React Developer',
      postedDate: 'Feb 10',
      applicants: 42,
      views: 230,
      status: JobStatus.active,
    ),
    JobPost(
      id: '2',
      title: 'Product Designer',
      postedDate: 'Feb 8',
      applicants: 28,
      views: 180,
      status: JobStatus.active,
    ),
    JobPost(
      id: '3',
      title: 'Data Scientist',
      postedDate: 'Feb 5',
      applicants: 35,
      views: 195,
      status: JobStatus.paused,
    ),
    JobPost(
      id: '4',
      title: 'Backend Engineer',
      postedDate: 'Jan 28',
      applicants: 19,
      views: 140,
      status: JobStatus.closed,
    ),
  ];

  void deleteJob(String id) {
    // Stub for delete
    notifyListeners();
  }
}

class RecruiterPostJobViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String jobTitle = '';
  String location = '';
  String salaryRange = '';
  String jobType = 'Full-time';
  String experienceLevel = 'Junior';
  String description = '';
  String skills = '';
  bool isLoading = false;

  final List<String> jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Remote',
  ];
  final List<String> experienceLevels = [
    'Junior',
    'Mid-level',
    'Senior',
    'Lead',
    'Manager',
  ];

  void setJobType(String value) {
    jobType = value;
    notifyListeners();
  }

  void setExperienceLevel(String value) {
    experienceLevel = value;
    notifyListeners();
  }

  Future<bool> publishJob() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      isLoading = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> saveDraft() async {
    formKey.currentState?.save();
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    notifyListeners();
    return true;
  }
}

class RecruiterCompanyViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String companyName = 'Cross Code';
  String website = '';
  String companySize = '—';
  String location = '';
  String industry = '';
  String about = '';
  bool isLoading = false;

  final List<String> companySizes = [
    '—',
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '500+',
  ];

  void setCompanySize(String value) {
    companySize = value;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      notifyListeners();
      return true;
    }
    return false;
  }
}
