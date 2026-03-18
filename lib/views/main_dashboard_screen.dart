import 'package:flutter/material.dart';
import 'package:jooblie_app/views/settings/settings_view.dart';
import '../core/app_colors.dart';
import '../core/utils/routes_name.dart';
import 'recruiter/recruiter_dashboard_view/recruiter_dashboard_view.dart';
import 'recruiter/recruiter_jobs_view/recruiter_jobs_view.dart';
import 'recruiter/recruiter_post_job_view/recruiter_post_job_view.dart';
import 'recruiter/recruiter_company_view.dart';
import 'job_seeker/job_seeker_home_view/jobseeker_home_view.dart';
import 'job_seeker/job_seeker_applications_view/jobseeker_applications_view.dart';
import 'job_seeker/job_seeker_recommendation_view/jobseeker_recommendations_view.dart';
import 'job_seeker/jobseeker_resume_view/jobseeker_resume_view.dart';
import 'job_seeker/job_seeker_profile_view/jobseeker_profile_view.dart';
import 'job_seeker/job_seeker_jobs_view/jobseeker_jobs_view.dart';

// ─── Tab Model ───────────────────────────────────────────────────────────────
class _TabItem {
  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  const _TabItem({required this.label, required this.selectedIcon, required this.unselectedIcon});
}

// ─── Custom Bottom Nav Bar (LinkedIn / Indeed style) ─────────────────────────
class _PremiumBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_TabItem> items;
  final ValueChanged<int> onTap;

  const _PremiumBottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated indicator pill at top
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          height: 3,
                          width: isSelected ? 28 : 0,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected ? item.selectedIcon : item.unselectedIcon,
                            key: ValueKey(isSelected),
                            size: 24,
                            color: isSelected
                                ? AppColors.lightPrimary
                                : (isDark ? Colors.white54 : Colors.black45),
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.lightPrimary
                                : (isDark ? Colors.white54 : Colors.black45),
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Tab body with smooth fade animation ─────────────────────────────────────
class _AnimatedTabBody extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screens;

  const _AnimatedTabBody({required this.currentIndex, required this.screens});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey<int>(currentIndex),
        child: screens[currentIndex],
      ),
    );
  }
}

// ─── Main Dashboard Screen ────────────────────────────────────────────────────
class MainDashboardScreen extends StatefulWidget {
  final bool isJobSeeker;
  const MainDashboardScreen({super.key, required this.isJobSeeker});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  static final List<Widget> _jobSeekerScreens = [
    const JobseekerHomeView(),
    const JobSeekerJobsView(),
    const JobseekerApplicationsView(),
    const JobseekerRecommendationsView(),
    const JobseekerResumeView(),
  ];

  static final List<Widget> _recruiterScreens = [
    const RecruiterDashboardView(),
    const RecruiterJobsView(),
    const RecruiterPostJobView(),
     SettingsView(
      title: "Company Profile",
      subTitle: "Edit your company information",
      routeName: RoutesName.companyView,
       showLeadingIcon: false,
    )
    // const RecruiterCompanyView(),
  ];

  static const _jobSeekerTabs = [
    _TabItem(label: 'Home', selectedIcon: Icons.home_rounded, unselectedIcon: Icons.home_outlined),
    _TabItem(label: 'Jobs', selectedIcon: Icons.work_rounded, unselectedIcon: Icons.work_outlined),
    _TabItem(label: 'Applications', selectedIcon: Icons.list_alt_rounded, unselectedIcon: Icons.list_alt_outlined),
    _TabItem(label: 'Matches', selectedIcon: Icons.auto_awesome_rounded, unselectedIcon: Icons.auto_awesome_outlined),
    _TabItem(label: 'Resume', selectedIcon: Icons.description_rounded, unselectedIcon: Icons.description_outlined),
    // _TabItem(label: 'Setting', selectedIcon: Icons.settings, unselectedIcon: Icons.settings_outlined),
  ];

  static const _recruiterTabs = [
    _TabItem(label: 'Dashboard', selectedIcon: Icons.dashboard_rounded, unselectedIcon: Icons.dashboard_outlined),
    _TabItem(label: 'My Jobs', selectedIcon: Icons.list_alt_rounded, unselectedIcon: Icons.list_alt_outlined),
    _TabItem(label: 'Post Job', selectedIcon: Icons.add_box_rounded, unselectedIcon: Icons.add_box_outlined),
    _TabItem(label: 'Setting', selectedIcon: Icons.settings, unselectedIcon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screens = widget.isJobSeeker ? _jobSeekerScreens : _recruiterScreens;
    final tabs = widget.isJobSeeker ? _jobSeekerTabs : _recruiterTabs;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: _AnimatedTabBody(currentIndex: _currentIndex, screens: screens),
      bottomNavigationBar: _PremiumBottomNav(
        currentIndex: _currentIndex,
        items: tabs,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
