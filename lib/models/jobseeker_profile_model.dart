class JobseekerProfileModel {
  final String fullName;
  final String email;
  final String location;
  final String jobTitle;
  final String bio;
  final List<String> skills;

  const JobseekerProfileModel({
    required this.fullName,
    required this.email,
    required this.location,
    required this.jobTitle,
    required this.bio,
    required this.skills,
  });

  JobseekerProfileModel copyWith({
    String? fullName,
    String? email,
    String? location,
    String? jobTitle,
    String? bio,
    List<String>? skills,
  }) {
    return JobseekerProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      location: location ?? this.location,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
    );
  }
}
