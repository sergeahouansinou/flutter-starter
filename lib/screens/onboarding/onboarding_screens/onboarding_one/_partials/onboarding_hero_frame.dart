import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/_partials/onboarding_page_content.dart';
import 'package:flutter/material.dart';

class OnboardingHeroFrame extends StatelessWidget {
  const OnboardingHeroFrame({
    super.key,
    required this.page,
    required this.height,
  });

  final OnboardingPageContent page;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            page.image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            excludeFromSemantics: true,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.38, 0.75, 1],
                colors: [
                  page.background.withValues(alpha: 0),
                  page.background.withValues(alpha: 0.6),
                  page.background,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
