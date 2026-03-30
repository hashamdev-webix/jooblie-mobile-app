import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart';
import 'get_service_key.dart';
import '../models/apply_job_request.dart';
import 'package:jooblie_app/services/get_service_key.dart';

class ApiService {
  // Stub for future API calls
  static const String baseUrl = 'https://api.example.com/v1';

  Future<Map<String, dynamic>> login(String email, String password) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'user@example.com' && password == 'password') {
      return {'status': 'success', 'token': 'dummy_token'};
    }
    throw Exception('Invalid credentials');
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    return {'status': 'success', 'token': 'dummy_token'};
  }

  Future<Map<String, dynamic>> applyForJob(
    String jobId,
    ApplyJobRequest request,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User is not authenticated");
    }

    String? resumeUrl = request.resumeUrl;

    // If not provided in request, fetch from profile
    if (resumeUrl == null) {
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select('resume_path')
          .eq('id', user.id)
          .maybeSingle();

      resumeUrl = profileData?['resume_path'];
    }

    if (resumeUrl == null) {
      throw Exception("Please upload a resume before applying");
    }

    // Ensure resumes/ prefix is present as requested by the user
    final String formattedResumeUrl = resumeUrl.startsWith('resumes/')
        ? resumeUrl
        : 'resumes/$resumeUrl';

    final Map<String, dynamic> payload = {
      'job_id': jobId,
      'applicant_id': user.id,
      'resume_url': formattedResumeUrl,
      'cover_letter': request.coverLetter,
      'status': 'Pending',
    };

    // 1. Insert Application and get ID
    final appResponse = await Supabase.instance.client
        .from('applications')
        .insert(payload)
        .select('id')
        .single();

    final applicationId = appResponse['id'];

    // 2. Notifications Logic for Recruiter
    try {
      // Fetch Job Details to get Recruiter ID and Job Title
      final jobResponse = await Supabase.instance.client
          .from('jobs')
          .select('recruiter_id, title')
          .eq('id', jobId)
          .maybeSingle();

      if (jobResponse != null) {
        final recruiterId = jobResponse['recruiter_id'];
        final jobTitle = jobResponse['title'];

        // Fetch Job Seeker Name for the Notification Body
        final applicantProfile = await Supabase.instance.client
            .from('profiles')
            .select('full_name')
            .eq('id', user.id)
            .maybeSingle();

        final applicantName = applicantProfile?['full_name'] ?? 'A candidate';

        final title = 'New Application Received';
        final body = '$applicantName has applied for $jobTitle.';

        // Insert Notification into Database
        await Supabase.instance.client.from('notifications').insert({
          'user_id': recruiterId,
          'title': title,
          'body': body,
          'type': 'new_application',
          'reference_id': applicationId,
          'is_read': false,
        });

        // Fetch Recruiter's Device Token for Push Notification
        final recruiterProfile = await Supabase.instance.client
            .from('profiles')
            .select('userDeviceToken')
            .eq('id', recruiterId)
            .maybeSingle();

        if (recruiterProfile != null) {
          final deviceToken = recruiterProfile['userDeviceToken'];
          if (deviceToken != null && deviceToken.toString().isNotEmpty) {
            // Send FCM HTTP v1 Request
            final GetServerKey getServerKey = GetServerKey();
            final String accessToken = await getServerKey.getServerKeyToken();

            final dio = Dio();
            dio.options.headers['Content-Type'] = 'application/json';
            dio.options.headers['Authorization'] = 'Bearer $accessToken';

            await dio.post(
              'https://fcm.googleapis.com/v1/projects/jooblienotifactions/messages:send',
              data: {
                'message': {
                  'token': deviceToken,
                  'notification': {'title': title, 'body': body},
                  'data': {
                    'type': 'new_application',
                    'applicationId': applicationId,
                    'targetUserId': recruiterId,
                  },
                },
              },
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error sending recruiter notification: $e');
    }

    // --- Notification Logic for Recruiter ---
    try {
      // 1. Fetch Job and Recruiter Info
      final jobData = await Supabase.instance.client
          .from('jobs')
          .select(
            'title, recruiter_id, profiles!jobs_recruiter_id_fkey(full_name, userDeviceToken)',
          )
          .eq('id', jobId)
          .maybeSingle();

      if (jobData != null) {
        final recruiterId = jobData['recruiter_id'];
        final jobTitle = jobData['title'];
        final applicantName =
            (await Supabase.instance.client
                .from('profiles')
                .select('full_name')
                .eq('id', user.id)
                .maybeSingle())?['full_name'] ??
            'A candidate';

        final title = 'New Application';
        final body = '$applicantName applied for $jobTitle';

        // 2. Save Notification to Supabase for Recruiter
        try {
          await Supabase.instance.client.from('notifications').insert({
            'user_id': recruiterId,
            'title': title,
            'body': body,
            'is_read': false,
          });
        } catch (_) {}

        // 3. Send FCM to Recruiter
        final deviceToken = jobData['profiles']?['userDeviceToken'];
        if (deviceToken != null && deviceToken.toString().isNotEmpty) {
          try {
            final GetServerKey getServerKey = GetServerKey();
            final String accessToken = await getServerKey.getServerKeyToken();

            final dio = Dio();
            dio.options.headers['Content-Type'] = 'application/json';
            dio.options.headers['Authorization'] = 'Bearer $accessToken';

            await dio.post(
              'https://fcm.googleapis.com/v1/projects/jooblienotifactions/messages:send',
              data: {
                'message': {
                  'token': deviceToken,
                  'notification': {'title': title, 'body': body},
                  'data': {
                    'type': 'new_application',
                    'jobId': jobId,
                    'targetUserId': recruiterId,
                  },
                },
              },
            );
          } catch (e) {
            print("Error sending FCM to recruiter: $e");
          }
        }
      }
    } catch (e) {
      print("Error in application notification trigger: $e");
    }

    return {
      'status': 'success',
      'message': 'Application submitted successfully',
    };
  }
}
