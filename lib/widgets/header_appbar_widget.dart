import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';

class HeaderAppBarWidget extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final String blackTitle;
  final String blueTitle;
  final bool showSetting;
  final bool showLeadingIcon;
  final bool showProfileIcon;
  final bool showNotificationIcon;

  const HeaderAppBarWidget({
    super.key,
    required this.theme,
    required this.isDark,
    this.blackTitle = "Joob",
    this.blueTitle = "lie",
    this.showSetting = true,
    this.showLeadingIcon = false,
    this.showProfileIcon = false,
    this.showNotificationIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment: showSetting
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            if (showLeadingIcon)
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios),
              ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: blackTitle,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: blueTitle,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            showSetting
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.settings);
                    },
                    icon: Icon(Icons.settings_outlined),
                  )
                : SizedBox.shrink(),
            if (showNotificationIcon)
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.notifications);
                },
                icon: Icon(Icons.notifications_none_rounded),
              ),
            if (showProfileIcon)
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.companyView);
                },
                icon: Icon(Bootstrap.person, color: AppColors.primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
