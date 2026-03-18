import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomHomeSearchBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onLocationTap;
  final String searchHint;
  final String locationHint;

  const CustomHomeSearchBar({
    super.key,
    this.onSearchTap,
    this.onLocationTap,
    this.searchHint = 'Search',
    this.locationHint = 'City, state, zip co...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,

          // color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        // boxShadow: [
        //   if (!isDark)
        //     BoxShadow(
        //       color: Colors.black.withValues(alpha: 0.05),
        //       blurRadius: 10,
        //       offset: const Offset(0, 4),
        //     ),
        // ],
      ),
      child: Row(
        children: [
          // Search Section
          Expanded(
            flex: 5,
            child: InkWell(
              onTap: onSearchTap,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                     Icon(Icons.search, size: 22, color:isDark ? Colors.white70 : Colors.black87),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        searchHint,
                        style:  TextStyle(
                          color:isDark ? Colors.white70 : Colors.black54,
                          fontSize: 16,
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
          Container(
            width: 1.5,
            height: 30,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),

          // Location Section
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: onLocationTap,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                     Icon(Icons.location_on_outlined, size: 22, color:isDark ? Colors.white70 : Colors.black87),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locationHint,
                        style:  TextStyle(
                          color:isDark ? Colors.white70 : Colors.black54,
                          fontSize: 16,
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
    );
  }
}
