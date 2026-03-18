import 'package:flutter/material.dart';
import 'package:jooblie_app/models/job_recommendation_model.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_recommendation_view/widgets/job_details_bottom_sheet.dart';
import 'dart:math' as math;
import '../../../../core/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  final JobRecommendationModel job;
  final ThemeData theme;
  final bool isDark;

  const RecommendationCard({
    required this.job,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        JobDetailsBottomSheet.show(context, job);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.work_outline,
              color: AppColors.lightPrimary,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            job.title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(job.company, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: isDark
                    ? AppColors.darkMutedForeground
                    : AppColors.lightMutedForeground,
              ),
              const SizedBox(width: 3),
              Text(
                job.location,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.attach_money,
                size: 14,
                color: isDark
                    ? AppColors.darkMutedForeground
                    : AppColors.lightMutedForeground,
              ),
              const SizedBox(width: 3),
              Text(
                job.salaryRange,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MatchCircle(percent: job.matchPercent),
              const SizedBox(width: 12),
              Text(
                'Match',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class _MatchCircle extends StatelessWidget {
  final int percent;

  const _MatchCircle({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(
        painter: _CirclePainter(percent: percent),
        child: Center(
          child: Text(
            '$percent%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.lightPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final int percent;

  _CirclePainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final strokeWidth = 1.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.lightPrimary.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = AppColors.lightPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percent / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.percent != percent;
}
