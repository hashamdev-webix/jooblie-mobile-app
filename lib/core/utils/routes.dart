import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/jobseeker_profile_view.dart';
import 'package:jooblie_app/views/login_screen.dart';
import 'package:jooblie_app/views/main_dashboard_screen.dart';
import 'package:jooblie_app/views/signup_screen.dart';
import 'package:jooblie_app/views/splash_screen.dart';
import 'package:jooblie_app/views/settings/settings_view.dart';
import 'package:jooblie_app/views/job_seeker/search_view/search_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (_) =>  SplashScreen());
      
      case RoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case RoutesName.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      
      case RoutesName.dashboard:
        final args = settings.arguments as Map<String, dynamic>?;
        final isJobSeeker = args?['isJobSeeker'] ?? true;
        return MaterialPageRoute(
          builder: (_) => MainDashboardScreen(isJobSeeker: isJobSeeker),
        );
      
      case RoutesName.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case RoutesName.profileView:
        return MaterialPageRoute(builder: (_) => const JobseekerProfileView());
      case RoutesName.search:
        return MaterialPageRoute(builder: (_) => const SearchView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
