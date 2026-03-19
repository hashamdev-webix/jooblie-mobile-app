import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();

  void initDeepLinks(BuildContext context) {
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(context, uri);
    });
  }

  void _handleDeepLink(BuildContext context, Uri uri) {
    // Logic to navigate to specific job details
    if (uri.pathSegments.contains('job')) {
      final jobId = uri.pathSegments.last;
      debugPrint('Navigate to job: $jobId');
      // Here you would find the job and show the bottom sheet or navigate
    }
  }

  static String generateJobLink(String jobId) {
    return 'https://jooblie.app/job/$jobId';
  }

  static Future<void> shareJob(String title, String jobId) async {
    final link = generateJobLink(jobId);
    await Share.share(
      'Check out this job on Jooblie: $title\n$link',
      subject: 'Job Opportunity on Jooblie',
    );
  }
}
