import 'package:flutter/cupertino.dart';

/// Where the incoming page travels *from*.
///
/// Mirrors the vocabulary of `AppFadeDirection` (`ui/components/app_fade_in.dart`)
/// so a screen entrance and its route entrance read the same way.
///
/// Directions are **literal**, not mirrored for RTL locales: `fromRight` always
/// starts at the right edge.
enum AppRouteDirection {
  /// Enters from the right edge — the natural "forward" push.
  fromRight,

  /// Enters from the left edge — reads as going *back* in a flow.
  fromLeft,

  /// Enters from the bottom edge — sheets, pickers, fullscreen dialogs.
  fromBottom,

  /// Enters from the top edge — notifications, search overlays.
  fromTop,

  /// No translation at all. Pair with [AppRouteEffect.fade],
  /// [AppRouteEffect.zoomIn] or [AppRouteEffect.zoomOut].
  none,
}

/// Opacity / scale treatment layered on top of the slide.
///
/// Every zoom also cross-fades: scaling a page without fading it makes its
/// edges pop, which reads as a glitch rather than as motion.
enum AppRouteEffect {
  /// Slide only, no fade and no scale.
  none,

  /// Cross-fade — the default, and the only effect kept when the user has
  /// "reduce motion" enabled.
  fade,

  /// Grows into place from 92 % — the page arrives *towards* the viewer.
  zoomIn,

  /// Settles into place from 108 % — the page arrives *away* from the viewer.
  zoomOut,
}

/// Enter in 300 ms: within the 150–300 ms responsive window.
const Duration _kEnterDuration = Duration(milliseconds: 300);

/// Leave in 220 ms — an exit should always feel quicker than an entrance.
const Duration _kExitDuration = Duration(milliseconds: 220);

/// Decelerating curve for entrances. Played backwards on `pop()` it becomes an
/// accelerating one, which is exactly what an exit wants — so a single curve
/// covers both directions.
const Curve _kCurve = Curves.easeOutCubic;

/// Full-width / full-height travel for the incoming page.
const double _kSlideFraction = 1.0;

/// How far the page underneath drifts while being covered.
const double _kParallaxFraction = 0.28;

/// How much the page underneath dims while being covered.
const double _kParallaxDim = 0.85;

/// How much the page underneath recedes on a vertical push.
const double _kParallaxScale = 0.96;

const double _kZoomInBegin = 0.92;
const double _kZoomOutBegin = 1.08;

/// A [PageRouteBuilder] that animates **both** pages of a navigation.
///
/// [direction] and [effect] are composable: pick where the new page comes from,
/// then how it materialises. `pop()` needs no configuration — it replays the
/// same transition backwards, faster.
///
/// ```dart
/// // forward push, the default: slides from the right + cross-fade
/// Navigator.of(context).push(AppPageRoute(const SignUpOne()));
///
/// // going back inside a flow
/// AppPageRoute(page, direction: AppRouteDirection.fromLeft);
///
/// // bottom sheet feel, page underneath recedes
/// AppPageRoute(page, direction: AppRouteDirection.fromBottom);
///
/// // pure zoom, no translation
/// AppPageRoute(page, direction: AppRouteDirection.none,
///     effect: AppRouteEffect.zoomIn);
///
/// // slide from the right while settling down from 108 %
/// AppPageRoute(page, effect: AppRouteEffect.zoomOut);
///
/// // instant, no motion at all
/// AppPageRoute(page, direction: AppRouteDirection.none,
///     effect: AppRouteEffect.none);
/// ```
///
/// What it does that a bare `PageRouteBuilder` does not:
///
/// - honours `secondaryAnimation`, so the page being covered drifts and dims
///   instead of sitting frozen underneath — the depth cue that tells the user
///   where they came from (disable with `parallax: false`);
/// - separates that depth cue from its own entrance via [parallaxDirection]:
///   a page can fade in yet still drift left when a `fromRight` route covers
///   it, which is what keeps the two metaphors from fighting;
/// - collapses to a plain cross-fade when the OS "reduce motion" setting is on;
/// - exits faster than it enters, with curves instead of linear tweens;
/// - wraps the page in a [RepaintBoundary] so its own repaints stay out of the
///   animating transform.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute(
    this.page, {
    this.direction = AppRouteDirection.fromRight,
    this.effect = AppRouteEffect.fade,
    Duration duration = _kEnterDuration,
    Duration reverseDuration = _kExitDuration,
    Curve curve = _kCurve,
    double slideFraction = _kSlideFraction,
    double? scaleBegin,
    bool parallax = true,
    this.parallaxDirection,
    super.opaque,
    super.maintainState,
    super.fullscreenDialog,
    String? name,
    RouteSettings? settings,
  }) : super(
          settings: name != null ? RouteSettings(name: name) : settings,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          pageBuilder: (_, _, _) => page,
          transitionsBuilder: _transitionsBuilder(
            direction: direction,
            effect: effect,
            curve: curve,
            slideFraction: slideFraction,
            scaleBegin: scaleBegin,
            parallax: parallax,
            parallaxDirection: parallaxDirection ?? direction,
          ),
        );

  final Widget page;
  final AppRouteDirection direction;
  final AppRouteEffect effect;

  /// Direction the *covering* route arrives from — what this page reacts to
  /// while it is being pushed away, as opposed to [direction], which is how it
  /// arrives itself.
  ///
  /// Defaults to [direction], which is right whenever a screen is covered the
  /// same way it appeared. Set it explicitly when the two differ: a screen that
  /// cross-fades in (`direction: none`) but gets covered by a `fromRight` push
  /// should still drift left, otherwise it recedes in Z while the incoming page
  /// travels sideways — two metaphors at once.
  final AppRouteDirection? parallaxDirection;

  /// Builds the transition for one configuration.
  ///
  /// `animation` drives this route's own entrance on `push()` and — replayed
  /// backwards — its exit on `pop()`. `secondaryAnimation` drives the *same*
  /// page once the next route covers it, which is what makes the parallax
  /// possible from a single builder.
  static RouteTransitionsBuilder _transitionsBuilder({
    required AppRouteDirection direction,
    required AppRouteEffect effect,
    required Curve curve,
    required double slideFraction,
    required double? scaleBegin,
    required bool parallax,
    required AppRouteDirection parallaxDirection,
  }) {
    return (context, animation, secondaryAnimation, child) {
      // Reduce Motion: translations and scales are dropped, never the route.
      if (MediaQuery.disableAnimationsOf(context)) {
        return FadeTransition(opacity: animation, child: child);
      }

      // Keeps the page's own painting off the animating transform layers.
      Widget content = RepaintBoundary(child: child);

      if (parallax) {
        content = _parallax(
          direction: parallaxDirection,
          animation: secondaryAnimation,
          curve: curve,
          child: content,
        );
      }

      if (effect != AppRouteEffect.none) {
        content = FadeTransition(
          opacity: _curved<double>(animation, curve, 0.0, 1.0),
          child: content,
        );
      }

      final scale = scaleBegin ?? _scaleBegin(effect);
      if (scale != null) {
        content = ScaleTransition(
          scale: _curved<double>(animation, curve, scale, 1.0),
          child: content,
        );
      }

      final begin = _beginOffset(direction, slideFraction);
      if (begin != Offset.zero) {
        content = SlideTransition(
          position: _curved<Offset>(animation, curve, begin, Offset.zero),
          child: content,
        );
      }

      return content;
    };
  }

  /// Motion applied to a page while the next route covers it.
  static Widget _parallax({
    required AppRouteDirection direction,
    required Animation<double> animation,
    required Curve curve,
    required Widget child,
  }) {
    final dimmed = FadeTransition(
      opacity: _curved<double>(animation, curve, 1.0, _kParallaxDim),
      child: child,
    );

    final horizontal = direction == AppRouteDirection.fromRight ||
        direction == AppRouteDirection.fromLeft;

    if (!horizontal) {
      // A vertical push reads as a sheet: the page underneath recedes rather
      // than sliding, which would fight the incoming motion.
      return ScaleTransition(
        scale: _curved<double>(animation, curve, 1.0, _kParallaxScale),
        child: dimmed,
      );
    }

    final away = direction == AppRouteDirection.fromRight
        ? const Offset(-_kParallaxFraction, 0)
        : const Offset(_kParallaxFraction, 0);

    return SlideTransition(
      position: _curved<Offset>(animation, curve, Offset.zero, away),
      child: dimmed,
    );
  }

  /// Curve-driven tween that adds no listener to [parent] — unlike a
  /// `CurvedAnimation`, which would accumulate one per rebuild.
  static Animation<X> _curved<X>(
    Animation<double> parent,
    Curve curve,
    X begin,
    X end,
  ) {
    return Tween<X>(begin: begin, end: end)
        .chain(CurveTween(curve: curve))
        .animate(parent);
  }

  static Offset _beginOffset(AppRouteDirection direction, double fraction) {
    switch (direction) {
      case AppRouteDirection.fromRight:
        return Offset(fraction, 0);
      case AppRouteDirection.fromLeft:
        return Offset(-fraction, 0);
      case AppRouteDirection.fromBottom:
        return Offset(0, fraction);
      case AppRouteDirection.fromTop:
        return Offset(0, -fraction);
      case AppRouteDirection.none:
        return Offset.zero;
    }
  }

  static double? _scaleBegin(AppRouteEffect effect) {
    switch (effect) {
      case AppRouteEffect.zoomIn:
        return _kZoomInBegin;
      case AppRouteEffect.zoomOut:
        return _kZoomOutBegin;
      case AppRouteEffect.fade:
      case AppRouteEffect.none:
        return null;
    }
  }
}

/// Route without any transition.
///
/// Note: [opaque] is `false`, so every route below stays painted even once
/// this one is idle. Kept as-is because `router_manager.dart` builds every
/// screen with it.
class NoAnimRouteBuilder<T> extends PageRouteBuilder<T> {
  NoAnimRouteBuilder(this.page)
      : super(
          opaque: false,
          pageBuilder: (_, _, _) => page,
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, _, _, child) => child,
        );

  final Widget page;
}

/// Cross-slides two explicit pages inside a [Stack].
///
/// Only useful when you hold the outgoing widget yourself; otherwise prefer
/// [AppPageRoute], which gets the same effect from `secondaryAnimation`
/// without rebuilding the previous page.
class EnterExitRoute<T> extends PageRouteBuilder<T> {
  EnterExitRoute({this.exitPage, required this.enterPage})
      : super(
          transitionDuration: _kEnterDuration,
          reverseTransitionDuration: _kExitDuration,
          pageBuilder: (context, animation, _) => enterPage,
          transitionsBuilder: (context, animation, _, child) {
            final curved = CurveTween(curve: _kCurve).animate(animation);
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-1.0, 0.0),
                  ).animate(curved),
                  child: exitPage,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(curved),
                  child: enterPage,
                ),
              ],
            );
          },
        );

  final Widget? exitPage;
  final Widget enterPage;
}

class KyNavigate {
  KyNavigate._();

  /// Native platform push — keeps the iOS back-swipe gesture.
  static PageRoute<T> slideIn<T extends Object?>(
    Widget widget, {
    String? name,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    PageRoute<Object>? hostRoute,
  }) {
    return CupertinoPageRoute<T>(
      builder: (_) => widget,
      settings: name != null ? RouteSettings(name: name) : settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static PageRoute<T> fadeIn<T extends Object?>(
    Widget widget, {
    String? name,
    RouteSettings? settings,
    bool maintainState = true,
  }) {
    return AppPageRoute<T>(
      widget,
      direction: AppRouteDirection.none,
      effect: AppRouteEffect.fade,
      name: name,
      settings: settings,
      maintainState: maintainState,
    );
  }
}

/// Cross-fade, no translation. Shorthand for
/// `AppPageRoute(page, direction: AppRouteDirection.none)`.
class FadeRouteBuilder<T> extends AppPageRoute<T> {
  FadeRouteBuilder(super.page) : super(direction: AppRouteDirection.none);
}

/// Slides down from the top edge. Shorthand for
/// `AppPageRoute(page, direction: AppRouteDirection.fromTop)`.
class SlideTopRouteBuilder<T> extends AppPageRoute<T> {
  SlideTopRouteBuilder(super.page)
      : super(direction: AppRouteDirection.fromTop);
}

/// Scales up from nothing. Kept for the existing call sites; a full 0 → 1 zoom
/// on a whole page is abrupt, so prefer
/// `AppPageRoute(page, effect: AppRouteEffect.zoomIn)` (92 % → 100 %).
class SizeRoute<T> extends AppPageRoute<T> {
  SizeRoute(super.page)
      : super(
          direction: AppRouteDirection.none,
          effect: AppRouteEffect.zoomIn,
          scaleBegin: 0.0,
        );
}
