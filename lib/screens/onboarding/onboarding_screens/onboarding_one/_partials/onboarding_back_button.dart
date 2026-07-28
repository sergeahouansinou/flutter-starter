import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingBackButton extends StatelessWidget {
  const OnboardingBackButton({
    super.key,
    required this.size,
    required this.color,
    required this.progress,
    required this.onPressed,
    this.gap = 12,
  });

  final double size;
  final Color color;
  final double progress;
  final double gap;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0);

    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: t,
        child: Opacity(
          opacity: t,
          child: Padding(
            padding: EdgeInsets.only(right: gap),
            child: Semantics(
              button: true,
              label: 'Page précédente',
              child: Material(
                color: color.withValues(alpha: 0.12),
                shape: CircleBorder(
                  side: BorderSide(color: color.withValues(alpha: 0.28)),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: t > 0.5 ? onPressed : null,
                  child: SizedBox.square(
                    dimension: size,
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      size: size * 0.42,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
