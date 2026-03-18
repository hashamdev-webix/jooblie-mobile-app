import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class JobsSearchHeader extends StatelessWidget {
  const JobsSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Search Jobs Input
          _buildInput(
            context,
            Icons.search,
            'Search jobs...',
            isDark,
          ),
          const SizedBox(height: 12),

          // Location Input
          _buildInput(
            context,
            Icons.location_on_outlined,
            'Location',
            isDark,
          ),
          const SizedBox(height: 16),

          // Filters Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_rounded, size: 20),
              label: const Text(
                'Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white70 : Colors.black54,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, IconData icon, String hint, bool isDark) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.white60 : Colors.black45),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
