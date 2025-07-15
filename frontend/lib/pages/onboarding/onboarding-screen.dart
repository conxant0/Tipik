import 'package:flutter/material.dart';
import 'package:frontend/pages/onboarding/onboarding_component.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';
import 'package:frontend/widgets/generic/gradient_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    OnboardingComponent(
      description:
          'Welcome to Tipik! From strokes to systems, Ipitik nato ang kabag-ohan.',
      mascotPath: 'assets/mascot/mascot-wave.gif',
    ),
    OnboardingComponent(
      description:
          "Simply snap a photo of your handwritten code — we'll instantly turn it into clean, executable code ready to run.",
      mascotPath: 'assets/mascot/mascot-pic.png',
    ),
    OnboardingComponent(
      description:
          "Get clear, beginner-friendly explanations of what your code does — perfect for students and curious minds.",
      mascotPath: 'assets/mascot/mascot-study.png',
    ),
    OnboardingComponent(
      description:
          "Got questions? Talk directly to our AI to understand errors, ask for suggestions, or improve your code logic.",
      mascotPath: 'assets/mascot/mascot-approve.png',
    ),
    OnboardingComponent(
      description:
          "Explore a variety of guided coding projects. We’ll walk you through the logic and structure step-by-step.",
      mascotPath: 'assets/mascot/mascot-coding.png',
    ),
    OnboardingComponent(
      description:
          "You're all set! Let’s turn your ideas — or notebook sketches — into real, running code. Get started now!",
      mascotPath: 'assets/mascot/mascot-yippie.png',
    ),
  ];

  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the main page or home page
      _onFinish();
    }
  }

  void _onFinish() {
    Navigator.pushReplacementNamed(context, '/nav');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/onboarding-bg.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),

          _currentIndex == _pages.length - 1
              ? SizedBox.shrink()
              : Positioned(
                  bottom: 20,
                  left: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.ocean, width: 2),
                    ),
                    child: ElevatedButton(
                      onPressed: _skip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          "Skip",
                          style: AppTextStyles.buttonText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

          // indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  spacing: 8,
                  dotColor: AppColors.lightGray,
                  activeDotColor: AppColors.ocean,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            right: 30,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.ocean, width: 2),
              ),
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    _currentIndex == _pages.length - 1 ? "Finish" : "Next",
                    style: AppTextStyles.buttonText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
