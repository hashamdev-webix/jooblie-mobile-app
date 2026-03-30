import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/jobseeker_profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class JobseekerProfileViewModel extends ChangeNotifier {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController locationController;
  late final TextEditingController jobTitleController;
  late final TextEditingController aboutController;
  late final TextEditingController skillsController;
  late final TextEditingController industryController;

  JobseekerProfileModel _profile = const JobseekerProfileModel(
    fullName: '',
    email: '',
    location: '',
    jobTitle: '',
    about: '',
    skills: [],
  );

  JobseekerProfileModel get profile => _profile;

  bool _isSaving = false;
  bool _isLoading = true;

  bool get isSaving => _isSaving;
  bool get isLoading => _isLoading;

  JobseekerProfileViewModel() {
    _initControllers();

    // Listen to Auth State to handle login/logout clearing
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.initialSession) {
        if (Supabase.instance.client.auth.currentUser != null) {
          _initProfile();
        }
      } else if (data.event == AuthChangeEvent.signedOut) {
        _clearProfile();
      }
    });

    skillsController.addListener(_onSkillsChanged);
  }

  void _clearProfile() {
    _profile = const JobseekerProfileModel(
      fullName: '',
      email: '',
      location: '',
      jobTitle: '',
      about: '',
      skills: [],
    );
    _isLoading = true;
    _initControllers();
    notifyListeners();
  }

  void _initControllers() {
    nameController = TextEditingController(text: _profile.fullName);
    emailController = TextEditingController(text: _profile.email);
    locationController = TextEditingController(text: _profile.location);
    jobTitleController = TextEditingController(text: _profile.jobTitle);
    industryController = TextEditingController(text: _profile.industry);
    aboutController = TextEditingController(text: _profile.about);
    skillsController = TextEditingController(text: _profile.skills.join(', '));
  }

  Future<void> _initProfile() async {
    try {
      // 1. Get fresh user data from server
      final userResponse = await Supabase.instance.client.auth.getUser();
      final user = userResponse.user;

      if (user == null) return;

      // 2. Fetch from Profiles table as secondary verification
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      final metadata = user.userMetadata;
      final String? fullName =
          profileData?['full_name'] ?? metadata?['full_name'];
      final String email = user.email ?? metadata?['email'] ?? '';
      final String? location =
          profileData?['location'] ?? metadata?['location'];
      final String? jobTitle =
          profileData?['job_title'] ?? metadata?['job_title'];
      final String? about = profileData?['about'] ?? metadata?['about'];
      List<String>? skills;
      final dynamic rawSkills = profileData?['skills'] ?? metadata?['skills'];

      if (rawSkills != null) {
        if (rawSkills is String) {
          try {
            final trimmed = rawSkills.trim();
            // Try to parse as JSON if it looks like an array
            if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
              final decoded = jsonDecode(trimmed);
              if (decoded is List) {
                skills = decoded
                    .map(
                      (e) => e
                          .toString()
                          .trim()
                          .replaceAll('"', '')
                          .replaceAll("'", ''),
                    )
                    .toList();
              }
            } else {
              // Fallback to comma-separated parsing
              skills = trimmed
                  .split(',')
                  .map((e) => e.trim().replaceAll('"', '').replaceAll("'", ''))
                  .where((e) => e.isNotEmpty)
                  .toList();
            }
          } catch (e) {
            // Final fallback: just strip brackets and quotes
            String cleaned = rawSkills
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '')
                .replaceAll("'", '')
                .trim();
            skills = cleaned
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          }
        } else if (rawSkills is List) {
          skills = rawSkills
              .map(
                (e) =>
                    e.toString().trim().replaceAll('"', '').replaceAll("'", ''),
              )
              .toList();
        }
      }

      // Use profile table's avatar_url if available, else metadata
      final String? avatarUrl =
          profileData?['avatar_url'] ?? metadata?['avatar_url'];

      debugPrint("✅ JobseekerProfileViewModel: Fresh avatar_url: $avatarUrl");

      _profile = _profile.copyWith(
        fullName: fullName ?? _profile.fullName,
        email: email,
        location: location ?? _profile.location,
        jobTitle: jobTitle ?? _profile.jobTitle,
        about: about ?? _profile.about,
        skills: skills ?? _profile.skills,
        avatarUrl: avatarUrl,
        isPrivateMode: profileData?['is_private_mode'] ?? false,
        industry: profileData?['industry'],
      );

      // Update controllers with fresh data
      nameController.text = _profile.fullName;
      emailController.text = _profile.email;
      locationController.text = _profile.location;
      jobTitleController.text = _profile.jobTitle;
      industryController.text = _profile.industry ?? '';
      aboutController.text = _profile.about;
      skillsController.text = _profile.skills.join(', ');

      _isLoading = false;
      notifyListeners();

      // Record self-view if first time
      await _recordSelfView(user.id);
    } catch (e) {
      debugPrint("Error initializing profile: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Records a view when the user visits their own profile for the first time
  Future<void> _recordSelfView(String userId) async {
    try {
      final existingView = await Supabase.instance.client
          .from('profile_views')
          .select('id')
          .eq('profile_id', userId)
          .eq('viewer_id', userId)
          .maybeSingle();

      if (existingView == null) {
        await Supabase.instance.client.from('profile_views').insert({
          'profile_id': userId,
          'viewer_id': userId,
        });
        debugPrint('Self-view recorded for $userId');
      }
    } catch (e) {
      debugPrint('Error recording self-view: $e');
    }
  }

  List<String> get parsedSkills {
    return skillsController.text
        .split(',')
        .map((s) => s.trim().replaceAll('"', '').replaceAll("'", ''))
        .where((s) => s.isNotEmpty)
        .toList();
  }

  File? _pickedImage;
  bool _isImageRemoved = false;

  File? get pickedImage => _pickedImage;

  bool get isImageRemoved => _isImageRemoved;

  void setIsPrivateMode(bool value) {
    _profile = _profile.copyWith(isPrivateMode: value);
    notifyListeners();
  }

  void _onSkillsChanged() {
    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      _pickedImage = File(image.path);
      _isImageRemoved = false;
      notifyListeners();
    }
  }

  void removeImage() {
    _pickedImage = null;
    _isImageRemoved = true;
    notifyListeners();
  }

  Future<String?> _uploadAvatar() async {
    if (_pickedImage == null) return _profile.avatarUrl;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final fileExt = _pickedImage!.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '${user.id}/$fileName';

      // 1. Upload to Supabase Storage
      await Supabase.instance.client.storage
          .from('profile_avatars')
          .upload(
            filePath,
            _pickedImage!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // 2. Get Public URL
      final publicUrl = Supabase.instance.client.storage
          .from('profile_avatars')
          .getPublicUrl(filePath);

      debugPrint(
        "✅ JobseekerProfileViewModel: Generated publicUrl: $publicUrl",
      );

      return publicUrl;
    } catch (e) {
      debugPrint("Error uploading avatar: $e");
      return null;
    }
  }

  Future<bool> saveChanges() async {
    _isSaving = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return false;

      String? finalAvatarUrl = _profile.avatarUrl;

      // 1. Handle Image Upload/Removal
      if (_isImageRemoved) {
        finalAvatarUrl = null;
      } else if (_pickedImage != null) {
        final uploadedUrl = await _uploadAvatar();
        if (uploadedUrl != null) {
          finalAvatarUrl = uploadedUrl;
        } else {
          // If upload failed, we might want to abort or continue without image update
          _isSaving = false;
          notifyListeners();
          return false;
        }
      }

      // 2. Update User Metadata
      final Map<String, dynamic> metadata = {
        ...user.userMetadata ?? {},
        'full_name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'job_title': jobTitleController.text.trim(),
        'about': aboutController.text.trim(),
        'industry': industryController.text.trim(),
        'is_private_mode': _profile.isPrivateMode,
        'skills': parsedSkills,
        'avatar_url': finalAvatarUrl,
      };

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: metadata),
      );

      // 3. Update Profiles Table
      await Supabase.instance.client
          .from('profiles')
          .update({
            'full_name': nameController.text.trim(),
            'job_title': jobTitleController.text.trim(),
            'avatar_url': finalAvatarUrl,
            'location': locationController.text.trim(),
            'about': aboutController.text.trim(),
            'industry': industryController.text.trim(),
            'is_private_mode': _profile.isPrivateMode,
            'skills': parsedSkills,
          })
          .eq('id', user.id);

      // 4. Update Local State
      _profile = _profile.copyWith(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        location: locationController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
        about: aboutController.text.trim(),
        industry: industryController.text.trim(),
        skills: parsedSkills,
        avatarUrl: finalAvatarUrl,
      );

      // Reset picking state
      _pickedImage = null;
      _isImageRemoved = false;

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
    aboutController.dispose();
    skillsController.dispose();
    industryController.dispose();
    super.dispose();
  }
}
