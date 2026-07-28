import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:flutter/material.dart';

class WelcomeFooterPrompt extends StatelessWidget {
  const WelcomeFooterPrompt({
    super.key,
    required this.question,
    required this.actionLabel,
    required this.onTap,
  });

  final String question;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WelcomePalette.of(context);
    final radius = BorderRadius.circular(10);

    return MergeSemantics(
      child: Semantics(
        button: true,
        child: Center(
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: question,
                    style: AppTextStyle.body(color: palette.muted),
                    children: [
                      TextSpan(
                        text: ' $actionLabel',
                        style: AppTextStyle.bodyEmphasis(color: palette.accent),
                      ),
                    ],
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
