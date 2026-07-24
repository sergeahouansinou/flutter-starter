import 'package:cardifly/anims/page_route_anim.dart';
import 'package:flutter/material.dart';

extension ContextUtils on BuildContext {
  Future<T?> goto<T>(Widget widget) =>
      Navigator.of(this).push<T>(KyNavigate.slideIn(widget));

  Future<T?> replaceWith<T>(Widget widget) => Navigator.of(this)
      .pushAndRemoveUntil<T>(KyNavigate.slideIn(widget), (_) => false);

  void pop<T>([T? result]) => Navigator.pop(this, result);

  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(this).cardColor;
  Color get surfaceTint => Theme.of(this).colorScheme.surfaceTint;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
