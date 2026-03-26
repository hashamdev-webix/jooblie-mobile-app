import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_post_model.dart';
import '../models/create_job_request_model.dart';
import '../models/recruiter_stats_model.dart';
import 'package:jooblie_app/services/get_service_key.dart';

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

      // 1. Fetch all jobs for this recruiter
      final jobsResponse = await Supabase.instance.client
          .from('jobs')
          .select()
          .eq('recruiter_id', userId);

      final List<dynamic> allJobs = jobsResponse as List<dynamic>;

      // Show ALL jobs in the count for now, as requested (no status filter)
      activeJobs = allJobs.length; 

      // 2. Fetch ALL applications for this recruiter's jobs to get accurate total count and hire rate
      final allAppsResponse = await Supabase.instance.client
          .from('applications')
          .select('status, jobs!inner(recruiter_id)')
          .eq('jobs.recruiter_id', userId);
          
      final List<dynamic> allApps = allAppsResponse as List<dynamic>;
      totalApplicants = allApps.length;
      
      final hiredCount = allApps.where((a) => a['status'] == 'Hired').length;
      hireRate = totalApplicants > 0 ? (hiredCount / totalApplicants) * 100 : 0.0;

      // 3. Fetch UNIQUE views for ALL jobs of this recruiter from the 'views' table
      int totalUniqueJobViews = 0;
      try {
        // Diagnostic: Check columns of views table
        try {
          final testResult = await Supabase.instance.client.from('views').select().limit(1);
          if (testResult.isNotEmpty) {
            debugPrint('DIAGNOSTIC - Views Table Columns: ${testResult.first.keys.toList()}');
          }
        } catch (_) {}

        final jobIds = allJobs.map((j) => j['id']).toList();
        if (jobIds.isNotEmpty) {
          final viewsResponse = await Supabase.instance.client
              .from('views')
              .select('job_id, viewer_id')
              .inFilter('job_id', jobIds);
          
          final List<dynamic> allViews = viewsResponse as List<dynamic>;
          
          // Count unique viewers across all jobs (as a total)
          final uniqueViewers = allViews.map((v) => v['viewer_id']).toSet();
          totalUniqueJobViews = uniqueViewers.length;

          // Also count per-job for top jobs logic
          for (var job in allJobs) {
            final jobViews = allViews.where((v) => v['job_id'] == job['id']).toList();
            job['unique_views_count'] = jobViews.map((v) => v['viewer_id']).toSet().length;
          }
        }
      } catch (e) {
        debugPrint('Error fetching unique job views: $e');
        // Fallback to legacy views if views table fails or is empty
        totalUniqueJobViews = allJobs.fold<int>(0, (sum, j) => sum + ((j['views'] ?? 0) as int));
      }
      jobViews = totalUniqueJobViews;

      // 4. Recent applicants: fetch from applications table joining profile info
      try {
        final applicantsResponse = await Supabase.instance.client
            .from('applications')
            .select('*, jobs!inner(title, recruiter_id), profiles:applicant_id(*)')
            .eq('jobs.recruiter_id', userId)
            .order('created_at', ascending: false)
            .limit(10);

        debugPrint('RAW Applicants Data: $applicantsResponse');

        final List<dynamic> appList = applicantsResponse as List<dynamic>;
        recentApplicants = appList.map((a) {
          try {
            final data = Map<String, dynamic>.from(a as Map);
            
            // Resolve full public URL for resume path
            final String? resUrl = data['resume_url']?.toString();
            if (resUrl != null && !resUrl.startsWith('http')) {
              final String path = resUrl.startsWith('resumes/') 
                  ? resUrl.replaceFirst('resumes/', '') 
                  : resUrl;
              data['resume_url'] = Supabase.instance.client.storage
                  .from('resumes')
                  .getPublicUrl(path);
            }
            
            return RecentApplicant.fromJson(data);
          } catch (e) {
            debugPrint('Error parsing applicant: $e');
            return null;
          }
        }).whereType<RecentApplicant>().toList();
        
        debugPrint('Final Recent Applicants Count: ${recentApplicants.length}');
      } catch (e, stack) {
        debugPrint('CRITICAL: Error fetching recruiter applicants: $e\n$stack');
        recentApplicants = [];
      }

      // 5. Top performing jobs (sort by applicants then views)
      final sortedJobs = List<dynamic>.from(allJobs);
      sortedJobs.sort((a, b) {
        int cmp = ((b['applicants'] ?? 0) as int).compareTo((a['applicants'] ?? 0) as int);
        if (cmp == 0) {
          int bViews = (b['unique_views_count'] ?? b['views'] ?? 0) as int;
          int aViews = (a['unique_views_count'] ?? a['views'] ?? 0) as int;
          cmp = bViews.compareTo(aViews);
        }
        return cmp;
      });
      
      topJobs = sortedJobs.take(3).map((j) => JobPerformance(
        id: j['id']?.toString() ?? '',
        title: j['title'] ?? 'Untitled',
        applicants: (j['applicants'] ?? 0) as int,
        views: (j['unique_views_count'] ?? j['views'] ?? 0) as int,
      )).toList();

    } catch (e) {
      debugPrint('Error fetching recruiter dashboard stats: $e');
      error = 'Failed to load stats.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordProfileView(String applicantId) async {
    try {
      final viewerId = Supabase.instance.client.auth.currentUser?.id;
      if (viewerId == null) return;

      // Don't record if viewing own profile (rare for recruiter)
      if (viewerId == applicantId) return;

      // Check if this viewer already viewed this profile to ensure uniqueness in the table
      // though the user wants to count unique, recording multiple is also fine but let's be efficient
      final existingView = await Supabase.instance.client
          .from('views')
          .select('id')
          .eq('profile_id', applicantId)
          .eq('viewer_id', viewerId)
          .maybeSingle();

      if (existingView == null) {
        await Supabase.instance.client.from('views').insert({
          'profile_id': applicantId,
          'viewer_id': viewerId,
        });
        debugPrint('Profile view recorded: applicant=$applicantId, viewer=$viewerId');
      }
    } catch (e) {
      debugPrint('Error recording profile view: $e');
    }
  }

  Future<void> recordJobView(String jobId) async {
    try {
      final viewerId = Supabase.instance.client.auth.currentUser?.id;
      if (viewerId == null) return;

      // Check for existing view
      final existingView = await Supabase.instance.client
          .from('views')
          .select('id')
          .eq('job_id', jobId)
          .eq('viewer_id', viewerId)
          .maybeSingle();

      if (existingView == null) {
        await Supabase.instance.client.from('views').insert({
          'job_id': jobId,
          'viewer_id': viewerId,
        });
        debugPrint('Job view recorded: job=$jobId, viewer=$viewerId');
        
        // Optionally update the legacy views counter in the jobs table
        // But the requirement is to use the views table.
      }
    } catch (e) {
      debugPrint('Error recording job view: $e');
      // Diagnostic: Check columns on failure
      try {
        final testResult = await Supabase.instance.client.from('views').select().limit(1);
        if (testResult.isNotEmpty) {
          debugPrint('DIAGNOSTIC (recordJobView) - Columns: ${testResult.first.keys.toList()}');
        }
      } catch (_) {}
    }
  }
}

class ApplicantDetailViewModel extends ChangeNotifier {
  ApplicationDetail? application;
  bool isLoading = false;
  String? error;
  bool isDownloading = false;
  double downloadProgress = 0.0;

  Future<void> fetchApplicationDetail(String applicationId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('applications')
          .select('*, jobs(title), profiles(*)')
          .eq('id', applicationId)
          .single();

      final data = Map<String, dynamic>.from(response);
      debugPrint('Raw Application Data: $data');
      
      // Resolve full public URL for resume if resume_url is a path
      final String? resumeUrl = data['resume_url']?.toString();
      if (resumeUrl != null && !resumeUrl.startsWith('http')) {
        // Strip 'resumes/' prefix if present because we are using .from('resumes')
        final String path = resumeUrl.startsWith('resumes/') 
            ? resumeUrl.replaceFirst('resumes/', '') 
            : resumeUrl;
            
        final fullUrl = Supabase.instance.client.storage
            .from('resumes')
            .getPublicUrl(path);
            
        data['resume_url'] = fullUrl;
      }

      application = ApplicationDetail.fromJson(data);

      // Record profile view by the recruiter
      try {
        final recruiterDashboardVM = RecruiterDashboardViewModel();
        await recruiterDashboardVM.recordProfileView(application!.applicantId);
      } catch (e) {
        debugPrint('Error triggering profile view record: $e');
      }
    } catch (e) {
      debugPrint('Error fetching application detail: $e');
      error = 'Failed to load application details.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStatus(String newStatus) async {
    if (application == null) {
      debugPrint('Update Status Failed: No application loaded');
      return false;
    }

    try {
      final appId = application!.applicationId;
      debugPrint('Supabase Update Attempt: table=applications, id=$appId, newStatus=$newStatus');
      
      // Attempt update WITHOUT .select() first to see if it throws an error
      // select() after an update can sometimes fail due to specific RLS select policies
      await Supabase.instance.client
          .from('applications')
          .update({'status': newStatus})
          .eq('id', appId);

      debugPrint('Supabase Update Command Sent Successfully');

        // Add Notification Logic
        try {
          final applicantId = application!.applicantId;
          final jobTitle = application!.jobTitle;
          final title = 'Application Update';
          final body = 'Your application for $jobTitle is now $newStatus';

          debugPrint('🔔 [Notifications] Starting notification process for user $applicantId');

          // 1. Save Notification to Supabase (Optional for Push)
          try {
            await Supabase.instance.client.from('notifications').insert({
              'user_id': applicantId,
              'title': title,
              'body': body,
              'is_read': false,
            });
            debugPrint('✅ [Notifications] Saved to DB');
          } catch (dbError) {
            debugPrint('⚠️ [Notifications] Failed to save to DB: $dbError');
            // We continue with Push Notification even if DB save fails
          }

          // 2. Fetch Device Token and Send FCM
          try {
            final profileResponse = await Supabase.instance.client
                .from('profiles')
                .select('userDeviceToken')
                .eq('id', applicantId)
                .maybeSingle();

            if (profileResponse != null) {
              final deviceToken = profileResponse['userDeviceToken'];
              if (deviceToken != null && deviceToken.toString().isNotEmpty) {
                debugPrint('🚀 [Notifications] Sending FCM to token: $deviceToken');
                
                final GetServerKey getServerKey = GetServerKey();
                final String accessToken = await getServerKey.getServerKeyToken(); 
                
                final dio = Dio();
                dio.options.headers['Content-Type'] = 'application/json';
                dio.options.headers['Authorization'] = 'Bearer $accessToken';
                
                final response = await dio.post(
                  'https://fcm.googleapis.com/v1/projects/jooblienotifactions/messages:send',
                  data: {
                    'message': {
                      'token': deviceToken,
                      'notification': {
                        'title': title,
                        'body': body,
                      },
                      'data': {
                        'type': 'status_update',
                        'applicationId': appId,
                        'targetUserId': applicantId,
                      }
                    }
                  },
                );
                debugPrint('✅ [Notifications] FCM Sent! Response: ${response.data}');
              } else {
                debugPrint('❌ [Notifications] Device token is null or empty for user $applicantId');
              }
            } else {
              debugPrint('❌ [Notifications] Profile not found for user $applicantId');
            }
          } catch (fcmError) {
            debugPrint('❌ [Notifications] FCM Send Error: $fcmError');
          }
        } catch (generalError) {
          debugPrint('❌ [Notifications] General Error: $generalError');
        }

      // Fetch updated data to reflect in UI and verify update
      await fetchApplicationDetail(appId);
      
      // Verify if the status actually changed
      if (application?.status == newStatus) {
        debugPrint('Update Verified: Status is now $newStatus');
        return true;
      } else {
        debugPrint('Update Check Failed: Status is still ${application?.status}. This confirms an RLS or permission issue.');
        return false;
      }
    } catch (e) {
      debugPrint('Postgrest Error updating status: $e');
      if (e is PostgrestException) {
        debugPrint('Details: ${e.message}, Hint: ${e.hint}, Code: ${e.code}');
      }
      return false;
    }
  }

  Future<void> downloadAndOpenResume(String url, String fileName) async {
    try {
      isDownloading = true;
      downloadProgress = 0.0;
      notifyListeners();

      final tempDir = await getTemporaryDirectory();
      // Ensure unique filename to avoid conflicts, or just use the provided one
      final String savePath = '${tempDir.path}/$fileName';

      final dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress = received / total;
            notifyListeners();
          }
        },
      );

      isDownloading = false;
      downloadProgress = 0.0;
      notifyListeners();

      // Open the downloaded file
      await OpenFilex.open(savePath);
    } catch (e) {
      debugPrint('Error downloading resume: $e');
      isDownloading = false;
      downloadProgress = 0.0;
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
            .map((s) => s.trim().replaceAll('"', '').replaceAll("'", ''))
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
