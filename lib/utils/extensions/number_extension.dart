import 'package:flutter/material.dart';

extension NumberExtension on int {
  /// Get Sized Box with width
  Widget get kWBox => SizedBox(width: toDouble());

  /// Get Sized Box with height
  Widget get kHBox => SizedBox(height: toDouble());
}
