import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/jobseeker_profile_model.dart';

class JobseekerProfileViewModel extends ChangeNotifier {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController locationController;
  late final TextEditingController jobTitleController;
  late final TextEditingController bioController;
  late final TextEditingController skillsController;

  JobseekerProfileModel _profile = const JobseekerProfileModel(
    fullName: 'Anas Tahir',
    email: 'anast4390@gmail.com',
    location: 'Lahore',
    jobTitle: 'Mobile App Developer',
    bio: 'I am AI Engineer.',
    skills: ['AI', 'Backend Developer', 'Digital Marketer'],
  );

  JobseekerProfileModel get profile => _profile;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  JobseekerProfileViewModel() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final metadata = user.userMetadata;
      final String? fullName = metadata?['full_name'];
      final String email = user.email ?? 'No email';
      final String? location = metadata?['location'];
      final String? jobTitle = metadata?['job_title'];
      final String? bio = metadata?['bio'];
      final List<String>? skills = (metadata?['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList();
      
      _profile = _profile.copyWith(
        fullName: fullName ?? _profile.fullName,
        email: email,
        location: location ?? _profile.location,
        jobTitle: jobTitle ?? _profile.jobTitle,
        bio: bio ?? _profile.bio,
        skills: skills ?? _profile.skills,
      );
    }

    nameController = TextEditingController(text: _profile.fullName);
    emailController = TextEditingController(text: _profile.email);
    locationController = TextEditingController(text: _profile.location);
    jobTitleController = TextEditingController(text: _profile.jobTitle);
    bioController = TextEditingController(text: _profile.bio);
    skillsController = TextEditingController(text: _profile.skills.join(', '));

    skillsController.addListener(_onSkillsChanged);
  }

  List<String> get parsedSkills {
    return skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void _onSkillsChanged() {
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    _isSaving = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final Map<String, dynamic> metadata = {
          'full_name': nameController.text.trim(),
          'location': locationController.text.trim(),
          'job_title': jobTitleController.text.trim(),
          'bio': bioController.text.trim(),
          'skills': parsedSkills,
        };
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(data: metadata),
        );
      }

      _profile = _profile.copyWith(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        location: locationController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
        bio: bioController.text.trim(),
        skills: parsedSkills,
      );
      
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    locationController.dispose();
    jobTitleController.dispose();
    bioController.dispose();
    skillsController.dispose();
    super.dispose();
  }
}
