import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:flutter/material.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    super.key,
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
    this.spacing = 12,
  });

  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final VoidCallback onFacebook;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final palette = WelcomePalette.of(context);

    return Column(
      children: [
        _button(palette, 'Continuer avec Google', 'google.svg', onGoogle),
        SizedBox(height: spacing),
        _button(
          palette,
          'Continuer avec Apple',
          'apple.svg',
          onApple,
          tint: palette.foreground,
        ),
        SizedBox(height: spacing),
        _button(palette, 'Continuer avec Facebook', 'facebook.svg', onFacebook),
      ],
    );
  }

  Widget _button(
    WelcomePalette palette,
    String label,
    String asset,
    VoidCallback onPressed, {
    Color? tint,
  }) {
    return AppButtonWidget(
      radius: 14,
      title: label,
      svgIcon: 'assets/svg/$asset',
      iconSize: 18,
      iconColor: tint,
      backgroundColor: palette.surface,
      borderColor: palette.outline,
      labelColor: palette.foreground,
      onPressed: onPressed,
    );
  }
}
