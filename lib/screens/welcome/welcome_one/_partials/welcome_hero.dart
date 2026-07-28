import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

/// Illustration, eyebrow, headline and supporting line of the welcome wall.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.illustrationHeight,
    this.illustrationAsset = 'assets/svg/onboarding.svg',
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  /// Sized by the screen so the artwork shrinks on short devices instead of
  /// pushing the buttons off.
  final double illustrationHeight;

  final String illustrationAsset;

  @override
  Widget build(BuildContext context) {
    final palette = WelcomePalette.of(context);

    return Column(
      children: [
        SvgPicture.asset(
          illustrationAsset,
          height: illustrationHeight,
          excludeFromSemantics: true,
        ),
        SizedBox(height: illustrationHeight * 0.2),
        Text(
          eyebrow.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyle.overline(color: palette.accent),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.display(color: palette.foreground),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyLg(color: palette.muted),
        ),
      ],
    );
  }
}
