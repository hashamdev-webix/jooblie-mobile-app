import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  String companyName = '';
  String fullName = '';
  String email = '';
  String website = '';
  String companySize = '—';
  String location = '';
  String industry = '';
  String about = '';
  bool isLoading = false;

  RecruiterCompanyViewModel() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      email = user.email ?? '';
      final metadata = user.userMetadata;
      if (metadata != null) {
        final cName = metadata['company_name'];
        if (cName != null && cName.toString().isNotEmpty) {
          companyName = cName.toString();
        }
        final fName = metadata['full_name'];
        if (fName != null && fName.toString().isNotEmpty) {
          fullName = fName.toString();
        }
        final web = metadata['website'];
        if (web != null && web.toString().isNotEmpty) website = web.toString();
        
        final size = metadata['company_size'];
        if (size != null && size.toString().isNotEmpty) companySize = size.toString();
        
        final loc = metadata['location'];
        if (loc != null && loc.toString().isNotEmpty) location = loc.toString();
        
        final ind = metadata['industry'];
        if (ind != null && ind.toString().isNotEmpty) industry = ind.toString();
        
        final abt = metadata['about'];
        if (abt != null && abt.toString().isNotEmpty) about = abt.toString();
      }
    }
  }

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
      
      try {
        final Map<String, dynamic> metadata = {
          'company_name': companyName,
          'website': website,
          'company_size': companySize,
          'location': location,
          'industry': industry,
          'about': about,
        };
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(data: metadata),
        );
        isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }
}
