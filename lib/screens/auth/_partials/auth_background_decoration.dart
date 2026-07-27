import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

class AuthBackgroundDecoration extends StatelessWidget {
  const AuthBackgroundDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          _circle(left: -40, top: -40, size: 200, opacity: 0.10),
          _circle(left: -40, bottom: -40, size: 200, opacity: 0.07),
          _circle(right: -100, top: -80, size: 400, opacity: 0.10),
        ],
      ),
    );
  }

  Widget _circle({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Constants.appPrimaryColor.withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
