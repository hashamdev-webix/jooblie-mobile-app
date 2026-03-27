import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/resume_model.dart';

class JobseekerResumeViewModel extends ChangeNotifier {
  ResumeModel? currentResume;
  bool isUploading = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;

  JobseekerResumeViewModel() {
    _fetchResume();
  }

  Future<void> downloadResume() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null || currentResume == null) return;

      final profileData = await Supabase.instance.client
          .from('profiles')
          .select('resume_path')
          .eq('id', user.id)
          .maybeSingle();

      final String? resumePath = profileData?['resume_path'];
      if (resumePath == null) return;

      isDownloading = true;
      downloadProgress = 0.0;
      notifyListeners();

      final signedUrl = await Supabase.instance.client.storage
          .from('resumes')
          .createSignedUrl(resumePath, 60);

      final tempDir = await getApplicationDocumentsDirectory();
      final String savePath = '${tempDir.path}/${currentResume!.fileName}';

      final dio = Dio();
      await dio.download(
        signedUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress = received / total;
            notifyListeners();
          }
        },
      );

      isDownloading = false;
      downloadProgress = 0.0;
      notifyListeners();

      await OpenFilex.open(savePath);
    } catch (e) {
      debugPrint('Error downloading resume: $e');
      isDownloading = false;
      downloadProgress = 0.0;
      notifyListeners();
    }
  }

  Future<void> _fetchResume() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final profileData = await Supabase.instance.client
          .from('profiles')
          .select(
            'resume_path, resume_file_name, resume_uploaded_at, resume_file_size',
          )
          .eq('id', user.id)
          .maybeSingle();

      if (profileData != null && profileData['resume_file_name'] != null) {
        final sizeVal = profileData['resume_file_size'];
        String sizeStr = '';
        if (sizeVal is int || sizeVal is double) {
          sizeStr = '${(sizeVal / 1024).round()} KB';
        } else if (sizeVal != null) {
          sizeStr = sizeVal.toString();
        }

        String formattedDate = '';
        if (profileData['resume_uploaded_at'] != null) {
          try {
            final dt = DateTime.parse(profileData['resume_uploaded_at']);
            formattedDate = '${_getMonth(dt.month)} ${dt.day}, ${dt.year}';
          } catch (e) {
            formattedDate = profileData['resume_uploaded_at'].toString().split(
              'T',
            )[0];
          }
        }

        currentResume = ResumeModel(
          fileName: profileData['resume_file_name'],
          uploadDate: formattedDate,
          fileSize: sizeStr,
          aiScore: 0,
          aiMessage: 'AI analysis pending...',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching resume: $e');
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> pickAndUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSizeB = await file.length();

        // Validate file size (5MB)
        if (fileSizeB > 5 * 1024 * 1024) {
          // Provide some alert/toast here normally
          debugPrint('File size must be less than 5MB');
          return;
        }

        isUploading = true;
        notifyListeners();

        final fileName = result.files.single.name;
        final fileExtension = fileName.split('.').last;

        final user = Supabase.instance.client.auth.currentUser;
        if (user == null) {
          isUploading = false;
          notifyListeners();
          return;
        }

        // Same path logic as React -> "userId.extension"
        final filePath = '${user.id}.$fileExtension';

        // Upload to Supabase Storage
        await Supabase.instance.client.storage
            .from('resumes')
            .upload(
              filePath,
              file,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: true,
              ),
            );

        final uploadDateISO = DateTime.now().toIso8601String();

        // Update Profiles Table
        await Supabase.instance.client
            .from('profiles')
            .update({
              'resume_path': filePath,
              'resume_uploaded_at': uploadDateISO,
              'resume_file_name': fileName,
              'resume_file_size': fileSizeB,
            })
            .eq('id', user.id);

        isUploading = false;
        notifyListeners();

        // Refresh Data
        await _fetchResume();
      }
    } catch (e) {
      debugPrint('Error uploading resume: $e');
      isUploading = false;
      notifyListeners();
    }
  }

  Future<void> deleteResume() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null || currentResume == null) return;

      // Need to find the stored resume_path
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select('resume_path')
          .eq('id', user.id)
          .maybeSingle();

      final String? resumePath = profileData?['resume_path'];

      if (resumePath != null) {
        // Delete from storage
        await Supabase.instance.client.storage.from('resumes').remove([
          resumePath,
        ]);
      }

      // Remove from profiles
      await Supabase.instance.client
          .from('profiles')
          .update({
            'resume_path': null,
            'resume_uploaded_at': null,
            'resume_file_name': null,
            'resume_file_size': null,
          })
          .eq('id', user.id);

      currentResume = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting resume: $e');
    }
  }
}
