import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_theme_provider.dart';
import 'core/utils/responsive.dart';
import 'viewmodels/recruiter_dashboard_viewmodel.dart';
import 'views/splash_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_)=>RecruiterJobsViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterDashboardViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterPostJobViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterCompanyViewModel())
      ],
      child: const JooblieApp(),
    ),
  );
}

class JooblieApp extends StatelessWidget {
  const JooblieApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utility
    Responsive.init(context);

    return Consumer<AppThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Jooblie',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
