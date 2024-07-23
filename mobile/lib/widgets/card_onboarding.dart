import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mobile/widgets/custom_button.dart';

class OnboardingPage extends StatelessWidget {
  final String logoPath;
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onNext;
  final int currentIndex;
  final int totalPages;

  const OnboardingPage({
    super.key,
    required this.logoPath,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onNext,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoPath,
                height: constraints.maxHeight * 0.14,
              ),
              const SizedBox(height: 16),
              Image.asset(
                imagePath,
                height: constraints.maxHeight * 0.4,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: PageController(initialPage: currentIndex),
                      count: totalPages,
                      effect: const ScrollingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: AppColors.white100,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white100,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.white100,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      icon: const Icon(Icons.arrow_forward),
                      label: 'Next',
                      receivedColor: AppColors.primary,
                      onPressed: onNext,
                      isEnabled: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
