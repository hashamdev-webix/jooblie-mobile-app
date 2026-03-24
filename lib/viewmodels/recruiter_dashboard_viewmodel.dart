import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_post_model.dart';
import '../models/create_job_request_model.dart';

import '../models/recruiter_stats_model.dart';

class RecruiterDashboardViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  // Stats
  int activeJobs = 0;
  int totalApplicants = 0;
  int jobViews = 0;
  double hireRate = 0.0;
  List<JobPerformance> topJobs = [];
  List<RecentApplicant> recentApplicants = [];

  RecruiterDashboardViewModel() {
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch all jobs for this recruiter
      final jobsResponse = await Supabase.instance.client
          .from('jobs')
          .select()
          .eq('recruiter_id', userId);

      final List<dynamic> allJobs = jobsResponse as List<dynamic>;

      // Active jobs count
      activeJobs = allJobs.where((j) => j['status'] == 'active').length;

      // Total applicants & views across all jobs
      totalApplicants = allJobs.fold<int>(0, (sum, j) => sum + ((j['applicants'] ?? 0) as int));
      jobViews = allJobs.fold<int>(0, (sum, j) => sum + ((j['views'] ?? 0) as int));

      // Hire rate: (hired / total applicants) * 100 — using a "hired" field if it exists, else 0
      final totalHired = allJobs.fold<int>(0, (sum, j) => sum + ((j['hired'] ?? 0) as int));
      hireRate = totalApplicants > 0 ? (totalHired / totalApplicants) * 100 : 0.0;

      // Top jobs sorted by applicants desc
      topJobs = allJobs
          .map((j) => JobPerformance.fromJson(j))
          .toList()
        ..sort((a, b) => b.applicants.compareTo(a.applicants));
      if (topJobs.length > 5) topJobs = topJobs.sublist(0, 5);

      // Recent applicants: fetch from applications table joining profile info
      try {
        final applicantsResponse = await Supabase.instance.client
            .from('applications')
            .select('job_id, jobs!inner(recruiter_id), profiles(full_name, job_title)')
            .eq('jobs.recruiter_id', userId)
            .order('created_at', ascending: false)
            .limit(5);

        final List<dynamic> appList = applicantsResponse as List<dynamic>;
        recentApplicants = appList.map((a) {
          final profile = a['profiles'] as Map<String, dynamic>?;
          return RecentApplicant.fromJson(profile ?? {});
        }).toList();
      } catch (_) {
        // applications table may not exist yet — silently ignore
        recentApplicants = [];
      }
    } catch (e) {
      debugPrint('Error fetching recruiter stats: $e');
      error = 'Failed to load stats.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class RecruiterJobsViewModel extends ChangeNotifier {
  List<JobPost> jobs = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMore = true;
  int _page = 0;
  final int _limit = 10;
  String currentFilter = 'all'; // all, active, expired, draft

  RecruiterJobsViewModel() {
    fetchJobs(refresh: true);
  }

  void setFilter(String status) {
    if (currentFilter != status) {
      currentFilter = status;
      fetchJobs(refresh: true);
    }
  }

  Future<void> fetchJobs({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      jobs.clear();
      hasMore = true;
      isLoading = true;
      notifyListeners();
    } else {
      if (!hasMore || isFetchingMore) return;
      isFetchingMore = true;
      notifyListeners();
    }

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        isLoading = false;
        isFetchingMore = false;
        notifyListeners();
        return;
      }

      var query = Supabase.instance.client
          .from('jobs')
          .select()
          .eq('recruiter_id', userId);

      if (currentFilter != 'all') {
        query = query.eq('status', currentFilter);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(_page * _limit, (_page + 1) * _limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      final newJobs = data.map((json) => JobPost.fromJson(json)).toList();

      if (newJobs.length < _limit) {
        hasMore = false;
      }

      jobs.addAll(newJobs);
      _page++;
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      await Supabase.instance.client.from('jobs').delete().eq('id', id);
      jobs.removeWhere((job) => job.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting job: $e');
    }
  }

  Future<void> updateJobStatus(String id, String status) async {
    try {
      await Supabase.instance.client
          .from('jobs')
          .update({'status': status})
          .eq('id', id);
      final idx = jobs.indexWhere((j) => j.id == id);
      if (idx != -1) {
        final old = jobs[idx];
        jobs[idx] = JobPost.fromJson({
          'id': old.id,
          'title': old.title,
          'company_name': old.companyName,
          'location': old.location,
          'job_type': old.jobType,
          'experience': old.experience,
          'salary_min': old.salaryMin,
          'salary_max': old.salaryMax,
          'salary_currency': old.salaryCurrency,
          'description': old.description,
          'requirements': old.requirements,
          'skills': old.skills,
          'created_at': old.postedDate.toIso8601String(),
          'applicants': old.applicants,
          'views': old.views,
          'status': status,
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating job status: $e');
    }
  }
}

class RecruiterPostJobViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? editingJobId;

  String jobTitle = '';
  String companyName = '';
  String location = '';
  String salaryMin = '';
  String salaryMax = '';
  String salaryCurrency = 'USD';
  String requirements = '';
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

  void loadJobForEditing(JobPost job) {
    editingJobId = job.id;
    jobTitle = job.title;
    companyName = job.companyName ?? '';
    location = job.location ?? '';
    salaryMin = job.salaryMin ?? '';
    salaryMax = job.salaryMax ?? '';
    salaryCurrency = job.salaryCurrency ?? 'USD';
    requirements = job.requirements ?? '';
    jobType = job.jobType ?? 'Full-time';
    experienceLevel = job.experience ?? 'Junior';
    description = job.description ?? '';
    skills = job.skills.join(', ');
    notifyListeners();
  }

  Future<bool> publishJob() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      isLoading = true;
      notifyListeners();
      
        // Fetch Recruiter Company Name from Profile before publishing
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          final profileData = await Supabase.instance.client
              .from('profiles')
              .select('company_name')
              .eq('id', user.id)
              .maybeSingle();
          
          if (profileData != null && profileData['company_name'] != null) {
            companyName = profileData['company_name'].toString();
          }
        }

        try {
          final List<String> skillsList = skills
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

        final request = CreateJobRequest(
          title: jobTitle,
          companyName: companyName,
          description: description,
          requirements: requirements,
          location: location,
          jobType: jobType,
          skills: skillsList,
          experience: experienceLevel,
          salaryMin: salaryMin.isNotEmpty ? salaryMin : null,
          salaryMax: salaryMax.isNotEmpty ? salaryMax : null,
          salaryCurrency: salaryCurrency.isNotEmpty ? salaryCurrency : null,
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );

        final userId = Supabase.instance.client.auth.currentUser?.id;
        final jobData = request.toJson();
        if (userId != null) {
          jobData['recruiter_id'] = userId;
        }

        if (editingJobId != null) {
          await Supabase.instance.client.from('jobs').update(jobData).eq('id', editingJobId!);
        } else {
          await Supabase.instance.client.from('jobs').insert(jobData);
        }
        
        editingJobId = null;
        jobTitle = '';
        companyName = '';
        location = '';
        salaryMin = '';
        salaryMax = '';
        requirements = '';
        description = ''; 
        skills = '';
        formKey.currentState?.reset();

        isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error publishing job: $e');
        isLoading = false;
        notifyListeners();
        return false;
      }
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
  bool isFirstLoad = true;

  RecruiterCompanyViewModel() {
    _initCompanyProfile();
  }

  Future<void> _initCompanyProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      email = user.email ?? '';
      isLoading = true;
      notifyListeners();
      
      try {
        final profileData = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
            
        final metadata = user.userMetadata;
        
        // Use profileData first, fallback to metadata
        final cName = profileData?['company_name'] ?? metadata?['company_name'];
        if (cName != null && cName.toString().isNotEmpty) companyName = cName.toString();

        final fName = profileData?['full_name'] ?? metadata?['full_name'];
        if (fName != null && fName.toString().isNotEmpty) fullName = fName.toString();

        final web = profileData?['website'] ?? metadata?['website'];
        if (web != null && web.toString().isNotEmpty) website = web.toString();

        final size = profileData?['company_size'] ?? metadata?['company_size'];
        if (size != null && size.toString().isNotEmpty) companySize = size.toString();

        final loc = profileData?['location'] ?? metadata?['location'];
        if (loc != null && loc.toString().isNotEmpty) location = loc.toString();

        final ind = profileData?['industry'] ?? metadata?['industry'];
        if (ind != null && ind.toString().isNotEmpty) industry = ind.toString();

        final abt = profileData?['about'] ?? metadata?['about'];
        if (abt != null && abt.toString().isNotEmpty) about = abt.toString();

        isFirstLoad = false;
        notifyListeners();
      } catch (e) {
        debugPrint('Error initializing recruiter profile: $e');
      } finally {
        isLoading = false;
        notifyListeners();
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
        final user = Supabase.instance.client.auth.currentUser;
        if (user == null) {
          isLoading = false;
          notifyListeners();
          return false;
        }

        final Map<String, dynamic> metadata = {
          'company_name': companyName,
          'full_name': fullName,
          'website': website,
          'company_size': companySize,
          'location': location,
          'industry': industry,
          'about': about,
        };
        
        // 1. Update user metadata
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(data: metadata),
        );

        // 2. Update profiles table
        await Supabase.instance.client
            .from('profiles')
            .update(metadata)
            .eq('id', user.id);

        isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error updating company profile: $e');
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }
}
