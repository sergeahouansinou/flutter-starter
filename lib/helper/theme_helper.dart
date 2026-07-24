import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  ThemeHelper._();

  static InputDecorationTheme inputDecorationTheme({required bool isDark}) {
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final hintColor = isDark ? Colors.white54 : Colors.black45;
    final fillColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : const Color(0xFFF3F5F9);
    const radius = 10.0;

    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: TextStyle(fontSize: 12, color: hintColor),
      enabledBorder: border(borderColor),
      focusedBorder: border(Constants.appPrimaryColor, width: 1.3),
      errorBorder: border(Colors.redAccent),
      focusedErrorBorder: border(Colors.redAccent, width: 1.3),
      disabledBorder: border(borderColor.withValues(alpha: 0.4)),
      border: border(borderColor),
    );
  }
}
