import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class AuthCardWidget extends StatelessWidget {
  const AuthCardWidget({
    super.key,
    required this.cardWidth,
    required this.theme,
    required this.child,
    // required this.isDark,
  });

  final double cardWidth;
  final ThemeData theme;

  final Widget child;
  // final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.black12
              : Colors.grey.shade100,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight,
        ],
      ),
      child: child,
    );
  }
}
