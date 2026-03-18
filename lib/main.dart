import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jooblie_app/core/utils/routes.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/viewmodels/jobseeker_applications_viewmodel.dart';
import 'package:jooblie_app/viewmodels/jobseeker_home_viewmodel.dart';
import 'package:jooblie_app/viewmodels/jobseeker_profile_viewmodel.dart';
import 'package:jooblie_app/viewmodels/jobseeker_recommendations_viewmodel.dart';
import 'package:jooblie_app/viewmodels/jobseeker_resume_viewmodel.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_theme_provider.dart';
import 'core/utils/responsive.dart';
import 'package:jooblie_app/viewmodels/job_seeker_jobs_viewmodel.dart';
import 'viewmodels/recruiter_dashboard_viewmodel.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_)=>RecruiterJobsViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterDashboardViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterPostJobViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterCompanyViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerHomeViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerApplicationsViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerRecommendationsViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerResumeViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerProfileViewModel()),
        ChangeNotifierProvider(create: (_)=>JobSeekerJobsViewModel()),
      ],
      child: const JooblieApp(),
    ),
  );
}


class JooblieApp extends StatelessWidget {
  const JooblieApp({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Consumer<AppThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.themeMode == ThemeMode.dark || 
                      (themeProvider.themeMode == ThemeMode.system && 
                       MediaQuery.of(context).platformBrightness == Brightness.dark);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
          child: MaterialApp(
            title: 'Jooblie',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: RoutesName.splash,
            onGenerateRoute: Routes.generateRoute,
          ),
        );
      },
    );
  }
}
