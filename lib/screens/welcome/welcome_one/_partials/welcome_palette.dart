import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Colours of the welcome wall, resolved for the current brightness.
///
/// [Constants.appPrimaryColor] is a deep navy: 8.9:1 on the light scaffold but
/// only 1.7:1 on the dark one, so the accent is lightened rather than reused
/// as-is.
@immutable
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

  final Color accent;
  final Color onAccent;
  final Color foreground;
  final Color muted;

  /// Fill of the secondary controls.
  final Color surface;

  final Color outline;
  final Color divider;
  final bool isDark;
}
