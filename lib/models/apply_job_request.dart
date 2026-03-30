class ApplyJobRequest {
  final String coverLetter;
  final String? resumeUrl;

  ApplyJobRequest({required this.coverLetter, this.resumeUrl});

  Map<String, dynamic> toJson() => {
    'cover_letter': coverLetter,
    if (resumeUrl != null) 'resume_url': resumeUrl,
  };
}
