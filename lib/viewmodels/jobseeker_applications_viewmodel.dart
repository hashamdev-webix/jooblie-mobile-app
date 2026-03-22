import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/job_application_model.dart';
import '../models/job_recommendation_model.dart';

class JobseekerApplicationsViewModel extends ChangeNotifier {
  List<JobApplicationModel> applications = [];
  bool isLoading = false;
  
  JobseekerApplicationsViewModel() {
    fetchApplications();
  }

  bool hasApplied(String jobId) {
    return applications.any((app) => app.jobId == jobId);
  }

  Future<void> fetchApplications() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await Supabase.instance.client
          .from('applications')
          .select('*, jobs(*)')
          .eq('applicant_id', user.id)
          .order('created_at', ascending: false);

      applications = (response as List).map((json) {
        final job = json['jobs'] ?? {};
        
        String formattedDate = '';
        if (json['created_at'] != null) {
          try {
            final dt = DateTime.parse(json['created_at']);
            formattedDate = DateFormat('MMM d, yyyy').format(dt);
          } catch (e) {
            formattedDate = json['created_at'].toString().split('T')[0];
          }
        }

        return JobApplicationModel(
          id: json['id']?.toString() ?? '',
          jobId: json['job_id']?.toString() ?? '',
          title: job['title']?.toString() ?? 'Unknown Title',
          company: job['company_name']?.toString() ?? 'Unknown Company',
          location: job['location']?.toString() ?? 'Unknown Location',
          date: formattedDate,
          status: json['status']?.toString() ?? 'Applied',
          jobData: JobRecommendationModel.fromJson(Map<String, dynamic>.from(job)),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching applications: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}

