import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.current,
    required this.activeColor,
    required this.inactiveColor,
    this.activeWidth = 44,
    this.spacing = 8,
  });

  /// Dot diameter, and the height of every slot.
  static const height = 10.0;

  final int count;
  final double current;
  final Color activeColor;
  final Color inactiveColor;
  final double activeWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${current.round() + 1} sur $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            _slot(i),
          ],
        ],
      ),
    );
  }

  Widget _slot(int index) {
    final t = (1 - (index - current).abs()).clamp(0.0, 1.0);

    return Container(
      width: height + (activeWidth - height) * t,
      height: height,
      decoration: BoxDecoration(
        color: Color.lerp(inactiveColor, activeColor, t),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
