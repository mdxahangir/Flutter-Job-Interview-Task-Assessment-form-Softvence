import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_alarm_app/common_widgets/onboarding_page.dart';
import 'package:travel_alarm_app/constants/app_constants.dart';
import 'package:travel_alarm_app/features/location/location_provider.dart';
import 'package:travel_alarm_app/features/location/location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompleteKey, true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: const LocationScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: AppConstants.onboardingTitles.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            imagePath: AppConstants.onboardingImages[index],
            title: AppConstants.onboardingTitles[index],
            description: AppConstants.onboardingDescriptions[index],
            isLastPage: index == 2,
            currentPage: _currentPage,
            totalPages: AppConstants.onboardingTitles.length,
            onSkip: _completeOnboarding,
            onNext: _goToNextPage,
          );
        },
      ),
    );
  }
}