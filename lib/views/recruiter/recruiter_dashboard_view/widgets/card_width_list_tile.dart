import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';

class CardWithListTile extends StatelessWidget {
  const CardWithListTile({
    super.key,
    required this.theme,
    required this.isDark,
    required this.items,
    required this.title,
    required this.itemBuilder,
  });

  final ThemeData theme;
  final bool isDark;
  final List items;
  final String title;
  final Widget Function(BuildContext, dynamic, int) itemBuilder;

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
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          16.h,
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return FadeInUp(
              delay: Duration(milliseconds: 550 + idx * 100),
              duration: const Duration(milliseconds: 400),
              child: itemBuilder(context, item, idx),
            );
          }),
        ],
      ),
    );
  }
}
