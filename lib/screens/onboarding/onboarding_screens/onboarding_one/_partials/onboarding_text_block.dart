import 'package:cardifly/ui/theme/app_text.dart';
import 'package:flutter/material.dart';

class OnboardingTextBlock extends StatelessWidget {
  const OnboardingTextBlock({
    super.key,
    required this.title,
    required this.body,
    required this.titleColor,
    required this.bodyColor,
  });

  static const titleSize = 48.0;
  static const bodySize = 17.0;
  static const titleLines = 2;
  static const bodyLines = 3;

  static const _titleLeading = 1.12;
  static const _bodyLeading = 1.5;
  static const _gap = 14.0;

  final String title;
  final String body;
  final Color titleColor;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: titleLines,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.display(color: titleColor).copyWith(
            fontSize: titleSize,
            height: _titleLeading,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: _gap),
        Text(
          body,
          maxLines: bodyLines,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.bodyLg(color: bodyColor).copyWith(
            fontSize: bodySize,
            height: _bodyLeading,
          ),
        ),
      ],
    );
  }

  static double heightFor(TextScaler scaler) {
    double block(double size, double leading, int lines) =>
        (scaler.scale(size) * leading).ceilToDouble() * lines;

    return block(titleSize, _titleLeading, titleLines) +
        _gap +
        block(bodySize, _bodyLeading, bodyLines);
  }
}
