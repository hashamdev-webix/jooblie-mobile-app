class ResumeModel {
  final String fileName;
  final String uploadDate;
  final String fileSize;
  final int aiScore;
  final String aiMessage;

  const ResumeModel({
    required this.fileName,
    required this.uploadDate,
    required this.fileSize,
    required this.aiScore,
    required this.aiMessage,
  });
}
