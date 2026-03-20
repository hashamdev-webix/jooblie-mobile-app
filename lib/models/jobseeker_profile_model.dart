class JobseekerProfileModel {
  final String fullName;
  final String email;
  final String location;
  final String jobTitle;
  final String bio;
  final List<String> skills;
  final String? avatarUrl;

  const JobseekerProfileModel({
    required this.fullName,
    required this.email,
    required this.location,
    required this.jobTitle,
    required this.bio,
    required this.skills,
    this.avatarUrl,
  });

  JobseekerProfileModel copyWith({
    String? fullName,
    String? email,
    String? location,
    String? jobTitle,
    String? bio,
    List<String>? skills,
    String? avatarUrl,
  }) {
    return JobseekerProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      location: location ?? this.location,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
