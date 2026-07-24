import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get height => size.height;
  double get width => size.width;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);
}
