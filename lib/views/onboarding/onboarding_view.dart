import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/widgets/gradient_style_text_widget.dart';
import 'package:jooblie_app/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/utils/routes_name.dart';
import '../../../viewmodels/onboarding_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final viewModel = context.watch<OnboardingViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_seen_onboarding', true);
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.login,
                          (route) => false,
                        );
                      }
                    },
                    child: GradientStyleTextWidget(title: 'Skip'),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: viewModel.setCurrentPage,
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image with Rounded Corners
                          FadeInDown(
                            duration: const Duration(milliseconds: 800),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                image: DecorationImage(
                                  image: AssetImage(item.imagePath),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Title
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          16.h,

                          // Description
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              item.description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isDark ? Colors.white70 : Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page Indicator and Next Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  children: [
                    // Dot Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        viewModel.items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: viewModel.currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            gradient: viewModel.currentPage == index
                                ? AppColors.gradientPrimary
                                : AppColors.gradientPrimary,
                            color: viewModel.currentPage == index
                                ? AppColors.lightPrimary
                                : AppColors.lightPrimary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Next Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),

                      child: PrimaryButton(
                        text: viewModel.isLastPage ? 'Get Started' : 'Next',
                        onPressed: () async {
                          if (viewModel.isLastPage) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('has_seen_onboarding', true);
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesName.login,
                                (route) => false,
                              );
                            }
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
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
}
