import 'package:flutter/material.dart';

@immutable
class OnboardingPageContent {
  const OnboardingPageContent({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.image,
    required this.background,
    required this.foreground,
    required this.ctaForeground,
  });

  final String title;
  final String body;
  final String actionLabel;
  final String image;
  final Color background;
  final Color foreground;
  final Color ctaForeground;

  Color get bodyColor => foreground.withValues(alpha: 0.72);

  Color get dimIndicator => foreground.withValues(alpha: 0.45);

  static const List<OnboardingPageContent> pages = [
    OnboardingPageContent(
      title: 'Le Code Est Déjà Écrit',
      body: 'Flutter, Dart et Firebase sont déjà câblés. Provider, Dio et le '
          'thème sombre fonctionnent.',
      actionLabel: 'Continuer',
      image: 'assets/images/img1.png',
      background: Color(0xFF0C0625),
      foreground: Colors.white,
      ctaForeground: Color(0xFF0C0625),
    ),
    OnboardingPageContent(
      title: 'Des Écrans À La Carte',
      body: 'Chaque écran existe en plusieurs designs. Gardez celui qui vous '
          'plaît, effacez les autres.',
      actionLabel: 'Continuer',
      image: 'assets/images/img2.png',
      background: Color(0xFF261E7F),
      foreground: Colors.white,
      ctaForeground: Color(0xFF261E7F),
    ),
    OnboardingPageContent(
      title: 'Livrez Sans Attendre',
      body: 'Branchez votre API, ajustez les couleurs et le thème, et votre '
          'application part en production.',
      actionLabel: 'Commencer',
      image: 'assets/images/img3.png',
      background: Color(0xFF180D22),
      foreground: Colors.white,
      ctaForeground: Color(0xFF180D22),
    ),
  ];
}
