import 'package:flutter/material.dart';

// theme
import 'package:frontend/theme/colors.dart';
import 'package:frontend/theme/text_styles.dart';

class OnboardingComponent extends StatelessWidget {
  final String description;
  final String mascotPath;

  const OnboardingComponent({
    super.key,
    required this.description,
    required this.mascotPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(flex: 1), // Spacer to push content down
        // Description
        Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                style: AppTextStyles.onboardingText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Mascot Image
        Center(
          child: Image.asset(
            mascotPath,
            width: 300, // Adjust size as needed
            height: 300, // Adjust size as needed
          ),
        ),

        SizedBox(height: 25), // Spacer to push content up
      ],
    );
  }
}
