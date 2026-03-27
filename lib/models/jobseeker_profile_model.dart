class JobseekerProfileModel {
  final String fullName;
  final String email;
  final String location;
  final String jobTitle;
  final String about;
  final List<String> skills;
  final String? avatarUrl;
  final bool isPrivateMode;
  final String? industry;

  const JobseekerProfileModel({
    required this.fullName,
    required this.email,
    required this.location,
    required this.jobTitle,
    required this.about,
    required this.skills,
    this.avatarUrl,
    this.isPrivateMode = false,
    this.industry,
  });

  JobseekerProfileModel copyWith({
    String? fullName,
    String? email,
    String? location,
    String? jobTitle,
    String? about,
    List<String>? skills,
    String? avatarUrl,
    bool? isPrivateMode,
    String? industry,
  }) {
    return JobseekerProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      location: location ?? this.location,
      jobTitle: jobTitle ?? this.jobTitle,
      about: about ?? this.about,
      skills: skills ?? this.skills,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPrivateMode: isPrivateMode ?? this.isPrivateMode,
      industry: industry ?? this.industry,
    );
  }
}
