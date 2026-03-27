import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/utils/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    delayedNavigate();
  }

  // Navigate after 3 seconds with session and onboarding logic
  Future<void> delayedNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // Guard: If another route (like ResetPassword) has already been pushed, don't navigate.
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    if (!hasSeenOnboarding) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.onboarding);
      }
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    final hasLoggedInManually = prefs.getBool('has_logged_in_manually') ?? false;

    if (session != null && hasLoggedInManually) {
      final user = session.user;
      // Verify email is confirmed if required by your Supabase setup.
      // It's normally filled via checking emailConfirmedAt
      if (user.emailConfirmedAt != null) {
        final userType = user.userMetadata?['role'];
        final isJobSeeker = userType != null
            ? (userType == 'job_seeker')
            : (prefs.getBool('is_job_seeker') ?? true);

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            RoutesName.dashboard,
            arguments: {'isJobSeeker': isJobSeeker},
          );
        }
        return;
      }
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientPrimary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            isDark
                                ? AppColors.shadowCardDark
                                : AppColors.shadowCardLight,
                          ],
                        ),
                        child: const Icon(
                          Icons.work_outline,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Jooblie',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.lightForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Find your next adventure',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark ? Colors.white70 : AppColors.lightMutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}