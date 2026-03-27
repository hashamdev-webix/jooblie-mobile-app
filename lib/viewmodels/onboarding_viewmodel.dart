import 'package:flutter/material.dart';

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final List<OnboardingContent> _items = [
    OnboardingContent(
      title: 'Find Your Dream Job',
      description:
          'Discover thousands of job opportunities tailored to your skills and preferences. Your next career move starts with Jooblie.',
      imagePath: 'assets/images/onboarding/onboarding_1.png',
    ),
    OnboardingContent(
      title: 'Smart Matching',
      description:
          'Our AI-powered engine matches you with the most relevant jobs, saving you time and effort in your job search.',
      imagePath: 'assets/images/onboarding/onboarding_2.png',
    ),
    OnboardingContent(
      title: 'Get Hired Faster',
      description:
          'Connect directly with recruiters and track your application status in real-time. Jooblie makes hiring simple.',
      imagePath: 'assets/images/onboarding/onboarding_3.png',
    ),
  ];

  List<OnboardingContent> get items => _items;

  void setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  bool get isLastPage => _currentPage == _items.length - 1;
}
