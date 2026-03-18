import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/header_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/app_theme_provider.dart';
import 'package:jooblie_app/core/sized.dart';


class SettingsView extends StatelessWidget {
  final String title;
  final String subTitle;
  final String routeName;
  final bool showLeadingIcon;

  const SettingsView({super.key,  this.title="My Profile",this.subTitle="Edit your personal information",


  this.routeName= RoutesName.profileView,
    this.showLeadingIcon=true
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBarWidget(title: "Setting",
      // showAppLogo: false,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBarWidget(title: "Setting"),
              HeaderAppBarWidget(theme: theme, isDark: isDark,
              blackTitle: "settings",
          showLeadingIcon: showLeadingIcon,
          blueTitle: "",
                showSetting: false,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: _SectionHeader(title: 'Account'),
                    ),
                    12.h,
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: _SettingsTile(
                        icon: Icons.person_outline_rounded,
                        title:title,
                        subtitle: subTitle,
                        onTap: () {
                          Navigator.pushNamed(context,routeName);
                        },
                      ),
                    ),
                    24.h,
                    FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionHeader(title: 'Appearance'),
                    ),
                    12.h,
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400),
                      child: _SettingsTile(
                        icon: Icons.palette_outlined,
                        title: 'Theme',
                        subtitle: _getThemeName(context),
                        onTap: () => _showThemeBottomSheet(context),
                      ),
                    ),
                    24.h,
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionHeader(title: 'About App'),
                    ),
                    12.h,
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'Read our terms and privacy policy',
                            onTap: () {
                              // Navigate to logic
                            },
                          ),
                          12.h,
                          _SettingsTile(
                            icon: Icons.share_outlined,
                            title: 'Share App',
                            subtitle: 'Share Jooblie with your friends',
                            onTap: () {
                              // Share logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeName(BuildContext context) {
    final mode = context.read<AppThemeProvider>().themeMode;
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
    }
  }

  void _showThemeBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('Select Theme'),
          message: const Text('Choose your preferred appearance'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                context.read<AppThemeProvider>().setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
              child: const Text('System Default'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                context.read<AppThemeProvider>().setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
              child: const Text('Light Mode'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                context.read<AppThemeProvider>().setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
              child: const Text('Dark Mode'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Select Theme',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              _ThemeOptionTile(
                title: 'System Default',
                icon: Icons.settings_brightness_outlined,
                mode: ThemeMode.system,
              ),
              _ThemeOptionTile(
                title: 'Light Mode',
                icon: Icons.light_mode_outlined,
                mode: ThemeMode.light,
              ),
              _ThemeOptionTile(
                title: 'Dark Mode',
                icon: Icons.dark_mode_outlined,
                mode: ThemeMode.dark,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.lightPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.lightPrimary, size: 22),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode mode;

  const _ThemeOptionTile({
    required this.title,
    required this.icon,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final currentMode = context.watch<AppThemeProvider>().themeMode;
    final isSelected = currentMode == mode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.lightPrimary : (isDark ? Colors.white54 : Colors.black54)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.lightPrimary : (isDark ? Colors.white : Colors.black),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: AppColors.lightPrimary)
          : null,
      onTap: () {
        context.read<AppThemeProvider>().setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
