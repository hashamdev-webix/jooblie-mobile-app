import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ProfileFieldWidget extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final IconData? icon;
  final ThemeData theme;
  final bool isDark;
  final TextInputType keyboardType;
  final bool showIcon;
  final String? hintText;
  final bool enabled;

  const ProfileFieldWidget({
    this.label,
    required this.controller,
    this.icon,
    required this.theme,
    required this.isDark,
    this.keyboardType = TextInputType.text,
    this.showIcon = true,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            color: enabled ? null : (isDark ? Colors.white54 : Colors.black54),
          ),

          decoration: InputDecoration(
            prefixIcon: showIcon
                ? Icon(
                    icon,
                    size: 18,
                    color: isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.lightMutedForeground,
                  )
                : null,
            filled: true,
            fillColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
