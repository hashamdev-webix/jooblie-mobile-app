import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jooblie_app/services/supabase_service.dart';
import 'package:jooblie_app/repositories/auth_repository.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';
import 'package:jooblie_app/core/services/deep_link_service.dart';
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
import 'package:jooblie_app/viewmodels/onboarding_viewmodel.dart';
import 'package:jooblie_app/viewmodels/favorites_viewmodel.dart';
import 'package:jooblie_app/viewmodels/verify_email_viewmodel.dart';
import 'package:jooblie_app/viewmodels/companies_viewmodel.dart';
import 'package:jooblie_app/viewmodels/recruiter_dashboard_viewmodel.dart';
import 'package:jooblie_app/services/network_service.dart';
import 'package:jooblie_app/views/no_internet_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  final supabaseService = SupabaseService();
  final authRepository = AuthRepository(supabaseService);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NetworkService()),
          ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
          ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterJobsViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterDashboardViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterPostJobViewModel()),
        ChangeNotifierProvider(create: (_)=>RecruiterCompanyViewModel()),
        ChangeNotifierProvider(create: (_)=>CompaniesViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerHomeViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerApplicationsViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerRecommendationsViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerResumeViewModel()),
        ChangeNotifierProvider(create: (_)=>JobseekerProfileViewModel()),
        ChangeNotifierProvider(create: (_)=>JobSeekerJobsViewModel()),
        ChangeNotifierProvider(create: (_)=>VerifyEmailViewModel()),
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
    DeepLinkService().initDeepLinks(context);

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
            builder: (context, child) {
              final easyLoadingChild = EasyLoading.init()(context, child);
              return Consumer<NetworkService>(
                builder: (context, network, _) {
                  return Stack(
                    children: [
                      if (easyLoadingChild != null) easyLoadingChild,
                      if (!network.isConnected)
                        const Directionality(
                          textDirection: TextDirection.ltr,
                          child: NoInternetScreen(),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
