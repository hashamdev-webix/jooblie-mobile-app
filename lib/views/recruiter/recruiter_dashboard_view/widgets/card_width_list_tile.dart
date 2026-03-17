import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/viewmodels/recruiter_dashboard_viewmodel.dart';
import 'package:jooblie_app/views/recruiter/recruiter_dashboard_view/widgets/dashboard_aplicant_tile_widget.dart';

class CardWithListTile extends StatelessWidget {
  const CardWithListTile({
    super.key,
    required this.theme,
    required this.isDark,
    required this.viewModel,
  });

  final ThemeData theme;
  final bool isDark;
  final RecruiterDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight,
        ],
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Applicants',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          16.h,
          ...viewModel.recentApplicants.asMap().entries.map((entry) {
            final idx = entry.key;
            final applicant = entry.value;
            return FadeInUp(
              delay: Duration(milliseconds: 550 + idx * 100),
              duration: const Duration(milliseconds: 400),
              child: DashboardApplicantTileWidget(applicant: applicant),
            );
          }),
        ],
      ),
    );
  }
}
