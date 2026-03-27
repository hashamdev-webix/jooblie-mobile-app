import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomHomeSearchBar extends StatelessWidget {
  final String searchHint;
  final String locationHint;
  final VoidCallback onSearchTap;
  final VoidCallback onLocationTap;

  const CustomHomeSearchBar({
    super.key,
    this.searchHint = 'Search',
    this.locationHint = 'City, state, zip co...',
    required this.onSearchTap,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Search Input
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: onSearchTap,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 20,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          searchHint,
                          style: TextStyle(
                            color: searchHint == 'Search'
                                ? (isDark ? Colors.white38 : Colors.black38)
                                : (isDark ? Colors.white : Colors.black87),
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Divider
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              indent: 10,
              endIndent: 10,
            ),
            // Location Input
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: onLocationTap,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locationHint,
                          style: TextStyle(
                            color: locationHint == 'City, state, zip co...'
                                ? (isDark ? Colors.white38 : Colors.black38)
                                : (isDark ? Colors.white : Colors.black87),
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
