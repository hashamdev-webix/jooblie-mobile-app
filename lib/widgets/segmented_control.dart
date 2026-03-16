import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SegmentedControl extends StatelessWidget {
  final bool isJobSeeker;
  final ValueChanged<bool> onChanged;

  const SegmentedControl({
    super.key,
    required this.isJobSeeker,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Using mapping from Tailwind mappings
    final backgroundColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final activeGradient = AppColors.gradientPrimary; 
    final inactiveTextColor = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Animated Sliding Background for active indicator
          AnimatedAlign(
            alignment: isJobSeeker ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: activeGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: theme.textTheme.labelLarge?.fontFamily,
                        color: isJobSeeker ? Colors.white : inactiveTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      child: const Text('Job Seeker'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: theme.textTheme.labelLarge?.fontFamily,
                        color: !isJobSeeker ? Colors.white : inactiveTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      child: const Text('Recruiter'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
