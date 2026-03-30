import 'package:crypto_tarde/features/onboarding/data/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: AppAssets.onboarding1,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
    ),
    OnboardingModel(
      image: AppAssets.onboarding2,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
    ),
    OnboardingModel(
      image: AppAssets.onboarding3,
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPageContent(_pages[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingModel page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              page.image,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.withOpacity(0.1),
                child: const Center(
                  child: Icon(Icons.image, color: Colors.grey, size: 100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0, left: 40.0, right: 40.0),
      child: Column(
        children: [
          // Row for Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => _buildIndicator(index == _currentIndex),
            ),
          ),
          const SizedBox(height: 40),
          // Custom Button
          CustomButton(
            text: _currentIndex == _pages.length - 1
                ? AppStrings.getStarted
                : AppStrings.next,
            onPressed: () {
              if (_currentIndex == _pages.length - 1) {
                context.go(AppRouter.auth);
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.white : AppColors.grey.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
