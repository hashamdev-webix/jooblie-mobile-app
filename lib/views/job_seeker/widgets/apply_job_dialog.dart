import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/models/job_recommendation_model.dart';
import 'package:jooblie_app/viewmodels/jobseeker_resume_viewmodel.dart';
import 'package:provider/provider.dart';

class ApplyJobDialog extends StatefulWidget {
  final JobRecommendationModel job;
  final bool isDark;

  const ApplyJobDialog({super.key, required this.job, required this.isDark});

  @override
  State<ApplyJobDialog> createState() => _ApplyJobDialogState();
}

class _ApplyJobDialogState extends State<ApplyJobDialog> {
  final TextEditingController coverLetterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      title: Text(
        'Apply for Job',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Write a short cover letter for ${widget.job.title} at ${widget.job.company}:',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 12),

            /// Cover Letter
            TextField(
              controller: coverLetterController,
              maxLines: 4,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'I would be a great fit because...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Resume Section
            Consumer<JobseekerResumeViewModel>(
              builder: (context, rVm, _) {
                if (rVm.isUploading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final hasResume = rVm.currentResume != null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasResume) ...[
                      Text(
                        rVm.currentResume!.fileName ?? 'Resume.pdf',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: rVm.pickAndUpload,
                        child: const Text('Change Resume'),
                      ),
                    ] else ...[
                      const Text(
                        'Upload resume first',
                        style: TextStyle(color: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: rVm.pickAndUpload,
                        child: const Text('Upload Resume'),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),

      /// Actions
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            final resumeVm = Provider.of<JobseekerResumeViewModel>(
              context,
              listen: false,
            );

            if (resumeVm.currentResume == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload resume first')),
              );
              return;
            }

            Navigator.pop(context, coverLetterController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
