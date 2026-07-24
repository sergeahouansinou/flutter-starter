import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Central design-system entry point for **text**.
///
/// Organises typography in three layers so callers pick the right level
/// of abstraction:
///
/// * [AppTextSize] — the raw pixel scale (compact by default).
/// * [AppFontWeight] / [AppLineHeight] / [AppTracking] — atomic tokens.
/// * [AppTextStyle] — ready-made [TextStyle]s composing the tokens above.
///
/// Use [AppTextStyle] in widgets. Reach for tokens only when you need to
/// override a single facet (`.copyWith(color: …)`).
///
/// The scale is **miniature-first** to match the rest of the starter — no
/// oversized headlines by default. Bump a level up (`h3` instead of `h4`)
/// if you need more prominence rather than tweaking the numbers inline.
class AppText {
  const AppText._();

  static const String fontFamily = 'Poppins';
}

// ─────────────────────────────────────────────────────────────
// Tokens
// ─────────────────────────────────────────────────────────────

/// Type scale — miniature, matches the compact widget set.
class AppTextSize {
  const AppTextSize._();

  static const double xxs = 9;
  static const double xs = 10;
  static const double sm = 11;
  static const double base = 12;
  static const double md = 13;
  static const double lg = 15;
  static const double xl = 18;
  static const double xxl = 22;
  static const double display = 28;
}

class AppFontWeight {
  const AppFontWeight._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

class AppLineHeight {
  const AppLineHeight._();

  static const double tight = 1.15;
  static const double normal = 1.4;
  static const double relaxed = 1.6;
}

class AppTracking {
  const AppTracking._();

  static const double tighter = -0.4;
  static const double tight = -0.2;
  static const double normal = 0;
  static const double wide = 0.3;
  static const double wider = 0.6;
}

// ─────────────────────────────────────────────────────────────
// Ready-made TextStyles
// ─────────────────────────────────────────────────────────────

/// Semantic text styles used across the app.
///
/// Prefer these over raw [TextStyle]s so typography stays consistent.
/// Each style is a factory returning a fresh instance so callers can
/// safely `.copyWith(...)` without mutating shared state.
///
/// Naming follows the common web/mobile convention:
/// `display` > `h1..h6` > `bodyLg/base/sm` > `caption` > `overline`.
///
/// Color defaults to the current theme's `onSurface` when [color] is
/// omitted — pass a color when you know you'll be rendered on top of
/// a contrasting background (gradient, colored card, etc.).
class AppTextStyle {
  const AppTextStyle._();

  // ── Display / Headings ────────────────────────────────────

  static TextStyle display({Color? color}) => _base(
        size: AppTextSize.display,
        weight: AppFontWeight.bold,
        height: AppLineHeight.tight,
        tracking: AppTracking.tighter,
        color: color,
      );

  static TextStyle h1({Color? color}) => _base(
        size: AppTextSize.xxl,
        weight: AppFontWeight.bold,
        height: AppLineHeight.tight,
        tracking: AppTracking.tight,
        color: color,
      );

  static TextStyle h2({Color? color}) => _base(
        size: AppTextSize.xl,
        weight: AppFontWeight.bold,
        height: AppLineHeight.tight,
        color: color,
      );

  static TextStyle h3({Color? color}) => _base(
        size: AppTextSize.lg,
        weight: AppFontWeight.semibold,
        height: AppLineHeight.tight,
        color: color,
      );

  static TextStyle h4({Color? color}) => _base(
        size: AppTextSize.md,
        weight: AppFontWeight.semibold,
        height: AppLineHeight.normal,
        color: color,
      );

  // ── Body ──────────────────────────────────────────────────

  static TextStyle bodyLg({Color? color}) => _base(
        size: AppTextSize.md,
        weight: AppFontWeight.regular,
        height: AppLineHeight.normal,
        color: color,
      );

  static TextStyle body({Color? color}) => _base(
        size: AppTextSize.base,
        weight: AppFontWeight.regular,
        height: AppLineHeight.normal,
        color: color,
      );

  static TextStyle bodySm({Color? color}) => _base(
        size: AppTextSize.sm,
        weight: AppFontWeight.regular,
        height: AppLineHeight.normal,
        color: color,
      );

  static TextStyle bodyEmphasis({Color? color}) => _base(
        size: AppTextSize.base,
        weight: AppFontWeight.semibold,
        height: AppLineHeight.normal,
        color: color,
      );

  // ── Interactive ───────────────────────────────────────────

  static TextStyle button({Color color = Colors.white}) => _base(
        size: AppTextSize.base,
        weight: AppFontWeight.semibold,
        height: AppLineHeight.tight,
        tracking: AppTracking.wide,
        color: color,
      );

  static TextStyle buttonSm({Color color = Colors.white}) => _base(
        size: AppTextSize.sm,
        weight: AppFontWeight.semibold,
        height: AppLineHeight.tight,
        tracking: AppTracking.wide,
        color: color,
      );

  static TextStyle link({Color? color}) => _base(
        size: AppTextSize.base,
        weight: AppFontWeight.medium,
        height: AppLineHeight.normal,
        color: color ?? Constants.appPrimaryColor,
      ).copyWith(decoration: TextDecoration.underline);

  // ── Auxiliary ─────────────────────────────────────────────

  static TextStyle caption({Color? color}) => _base(
        size: AppTextSize.xs,
        weight: AppFontWeight.regular,
        height: AppLineHeight.normal,
        color: color,
      );

  static TextStyle overline({Color? color}) => _base(
        size: AppTextSize.xxs,
        weight: AppFontWeight.semibold,
        height: AppLineHeight.tight,
        tracking: AppTracking.wider,
        color: color,
      ).copyWith(fontFeatures: const [FontFeature.enable('smcp')]);

  static TextStyle label({Color? color}) => _base(
        size: AppTextSize.sm,
        weight: AppFontWeight.medium,
        height: AppLineHeight.tight,
        color: color,
      );

  static TextStyle mono({Color? color}) => _base(
        size: AppTextSize.sm,
        weight: AppFontWeight.medium,
        height: AppLineHeight.normal,
        color: color,
      ).copyWith(fontFamily: 'monospace', letterSpacing: 0);

  // ── Internal helper ───────────────────────────────────────

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    required double height,
    double tracking = AppTracking.normal,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: tracking,
      color: color,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Theme bridge
// ─────────────────────────────────────────────────────────────

/// Maps the [AppTextStyle] family onto Flutter's [TextTheme] so it flows
/// through `Theme.of(context).textTheme` automatically. Wire this in
/// `ThemeModel.themeData()` via `textTheme: AppText.textThemeFor(...)`.
extension AppTextTheme on AppText {
  static TextTheme textThemeFor(Color onSurface) {
    Color muted(double alpha) => onSurface.withValues(alpha: alpha);
    return TextTheme(
      displayLarge: AppTextStyle.display(color: onSurface),
      displayMedium: AppTextStyle.h1(color: onSurface),
      displaySmall: AppTextStyle.caption(color: muted(0.6)),
      headlineLarge: AppTextStyle.h1(color: onSurface),
      headlineMedium: AppTextStyle.h2(color: onSurface),
      headlineSmall: AppTextStyle.h3(color: onSurface),
      titleLarge: AppTextStyle.h2(color: onSurface),
      titleMedium: AppTextStyle.h4(color: onSurface),
      titleSmall: AppTextStyle.label(color: muted(0.7)),
      bodyLarge: AppTextStyle.bodyLg(color: onSurface),
      bodyMedium: AppTextStyle.body(color: onSurface),
      bodySmall: AppTextStyle.bodySm(color: muted(0.75)),
      labelLarge: AppTextStyle.button(color: onSurface),
      labelMedium: AppTextStyle.label(color: onSurface),
      labelSmall: AppTextStyle.overline(color: muted(0.7)),
    );
  }
}
