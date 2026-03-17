import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class RecruiterPostJobFormCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const RecruiterPostJobFormCard({
    super.key,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: children,
      ),
    );
  }
}
