import 'package:flutter/material.dart';
import '../models/resume_model.dart';

class JobseekerResumeViewModel extends ChangeNotifier {
  ResumeModel? currentResume = const ResumeModel(
    fileName: 'AhmadIqbal_FrontEnd_Dev.pdf',
    uploadDate: 'Feb 24, 2026',
    fileSize: '234 KB',
    aiScore: 85,
    aiMessage:
        'Your resume scores 85/100. Consider adding more quantifiable achievements.',
  );

  bool isUploading = false;

  Future<void> pickAndUpload() async {
    isUploading = true;
    notifyListeners();
    // Simulate file pick delay
    await Future.delayed(const Duration(seconds: 1));
    isUploading = false;
    notifyListeners();
  }

  void deleteResume() {
    currentResume = null;
    notifyListeners();
  }
}
