import 'package:cardifly/anims/page_route_anim.dart';
import 'package:flutter/material.dart';

extension ContextUtils on BuildContext {
  /// Pushes a poppable screen.
  ///
  /// Stays on the platform route ([KyNavigate.slideIn]) rather than on
  /// [AppPageRoute]: it already slides in from the right, and it is the only
  /// one that keeps the iOS edge-swipe-back gesture. Pass an [AppPageRoute]
  /// straight to `Navigator.push` when a screen needs another direction:
  ///
  /// ```dart
  /// Navigator.of(context).push(
  ///   AppPageRoute(const FiltersSheet(),
  ///       direction: AppRouteDirection.fromBottom),
  /// );
  /// ```
  Future<T?> goto<T>(Widget widget) =>
      Navigator.of(this).push<T>(KyNavigate.slideIn(widget));

  /// Wipes the stack and shows [widget]. Cross-fades, since nothing is left to
  /// pop back to.
  Future<T?> replaceWith<T>(Widget widget) => Navigator.of(this)
      .pushAndRemoveUntil<T>(KyNavigate.fadeIn(widget), (_) => false);

  void pop<T>([T? result]) => Navigator.pop(this, result);

  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(this).cardColor;
  Color get surfaceTint => Theme.of(this).colorScheme.surfaceTint;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
