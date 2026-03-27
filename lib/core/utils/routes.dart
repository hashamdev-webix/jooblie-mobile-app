import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/views/job_seeker/job_seeker_profile_view/jobseeker_profile_view.dart';
import 'package:jooblie_app/views/login_screen.dart';
import 'package:jooblie_app/views/main_dashboard_screen.dart';
import 'package:jooblie_app/views/recruiter/recruiter_company_view.dart';
import 'package:jooblie_app/views/signup_screen.dart';
import 'package:jooblie_app/views/splash_screen.dart';
import 'package:jooblie_app/views/settings/settings_view.dart';
import 'package:jooblie_app/views/job_seeker/search_view/search_view.dart';
import 'package:jooblie_app/views/forgot_password_screen.dart';
import 'package:jooblie_app/views/job_seeker/search_view/location_search_view.dart';
import 'package:jooblie_app/views/onboarding/onboarding_view.dart';
import 'package:jooblie_app/views/job_seeker/favorites_view/favorites_view.dart';
import 'package:jooblie_app/views/verify_email_screen.dart';
import 'package:jooblie_app/views/reset_password_screen.dart';
import 'package:jooblie_app/models/company_model.dart';
import 'package:jooblie_app/views/job_seeker/companies_view/company_details_view.dart';
import 'package:jooblie_app/views/recruiter/applicant_detail_view/applicant_detail_view.dart';
import 'package:jooblie_app/views/notifications_view.dart';

import 'package:jooblie_app/views/job_seeker/profile_insights_view.dart';
import 'package:jooblie_app/views/recruiter/job_view_insights_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Handle root route or routes with query parameters from deep links
    if (settings.name == '/' ||
        (settings.name != null && settings.name!.startsWith('/?'))) {
      return MaterialPageRoute(builder: (_) => SplashScreen());
    }

    // Handle dynamic job routes from deep links
    if (settings.name != null && settings.name!.startsWith('/job/')) {
      final jobId = settings.name!.split('/').last;
      // For now, we return a scaffold that handles the job detail lookup.
      // In a real app, you'd navigate to a JobDetailsView.
      debugPrint('Deep Link for Job ID: $jobId');
      // For this demo, we can just return the dashboard or a dedicated view.
      return MaterialPageRoute(
        builder: (_) =>
            MainDashboardScreen(isJobSeeker: true, initialJobId: jobId),
      );
    }

    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case RoutesName.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());

      case RoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesName.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case RoutesName.dashboard:
        final args = settings.arguments as Map<String, dynamic>?;
        final isJobSeeker = args?['isJobSeeker'] ?? true;
        final initialIndex = args?['initialIndex'] ?? 0;
        final initialJobId = args?['initialJobId'];
        return MaterialPageRoute(
          builder: (_) => MainDashboardScreen(
            isJobSeeker: isJobSeeker,
            initialIndex: initialIndex,
            initialJobId: initialJobId,
          ),
        );

      case RoutesName.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case RoutesName.profileView:
        return MaterialPageRoute(builder: (_) => const JobseekerProfileView());
      case RoutesName.search:
        return MaterialPageRoute(builder: (_) => const SearchView());
      case RoutesName.locationSearch:
        return MaterialPageRoute(builder: (_) => const LocationSearchView());
      case RoutesName.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());

      case RoutesName.companyView:
        return MaterialPageRoute(builder: (_) => RecruiterCompanyView());
      case RoutesName.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ForgotPasswordScreen(),
        );

      case RoutesName.verifyEmail:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            final args = settings.arguments as Map<String, dynamic>?;
            final email = args?['email'] ?? '';
            final isFromForgotPassword = args?['isFromForgotPassword'] ?? false;
            return VerifyEmailScreen(
              email: email,
              isFromForgotPassword: isFromForgotPassword,
            );
          },
        );

      case RoutesName.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case RoutesName.companyDetails:
        final company = settings.arguments as CompanyModel;
        return MaterialPageRoute(
          builder: (_) => CompanyDetailsView(company: company),
        );

      case RoutesName.applicantDetail:
        final applicationId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ApplicantDetailView(applicationId: applicationId),
        );

      case RoutesName.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsView());
      case RoutesName.profileInsights:
        return MaterialPageRoute(builder: (_) => const ProfileInsightsView());
      case RoutesName.jobInsights:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => JobViewInsightsView(
            jobId: args['jobId'],
            jobTitle: args['jobTitle'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
