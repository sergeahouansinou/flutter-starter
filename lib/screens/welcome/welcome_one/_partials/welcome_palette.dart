import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

class WelcomePalette {
  const WelcomePalette._({
    required this.accent,
    required this.onAccent,
    required this.foreground,
    required this.muted,
    required this.surface,
    required this.outline,
    required this.divider,
    required this.isDark,
  });

  final Color accent;
  final Color onAccent;
  final Color foreground;
  final Color muted;
  final Color surface;
  final Color outline;
  final Color divider;
  final bool isDark;

  factory WelcomePalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return WelcomePalette._(
      accent: isDark ? const Color(0xFF5BA7DE) : Constants.appPrimaryColor,
      onAccent: isDark ? const Color(0xFF08243A) : Colors.white,
      foreground: onSurface,
      muted: onSurface.withValues(alpha: 0.65),
      surface: theme.cardColor,
      outline: onSurface.withValues(alpha: 0.22),
      divider: onSurface.withValues(alpha: 0.14),
      isDark: isDark,
    );
  }
}
