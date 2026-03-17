import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class RecruiterPostJObDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final bool isDark;

  const RecruiterPostJObDropdown({super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          style: theme.textTheme.bodyMedium,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark
                ? AppColors.darkMutedForeground
                : AppColors.lightMutedForeground,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
