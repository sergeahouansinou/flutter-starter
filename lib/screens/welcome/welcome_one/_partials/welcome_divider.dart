import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:flutter/material.dart';

class WelcomeDivider extends StatelessWidget {
  const WelcomeDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = WelcomePalette.of(context);
    final line = Expanded(child: Divider(color: palette.divider, height: 1));

    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          line,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * .75),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyle.bodySm(color: palette.muted),
              ),
            ),
          ),
          line,
        ],
      ),
    );
  }
}
