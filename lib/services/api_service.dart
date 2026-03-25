import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/apply_job_request.dart';

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

  Future<Map<String, dynamic>> applyForJob(String jobId, ApplyJobRequest request) async {
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
        ? resumeUrl : 'resumes/$resumeUrl';
    
    final Map<String, dynamic> payload = {
      'job_id': jobId,
      'applicant_id': user.id,
      'resume_url': formattedResumeUrl,
      'cover_letter': request.coverLetter,
      'status': 'Pending',
    };

    await Supabase.instance.client.from('applications').insert(payload);

    return {'status': 'success', 'message': 'Application submitted successfully'};
  }
}
