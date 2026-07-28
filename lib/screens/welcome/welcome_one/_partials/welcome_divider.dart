import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:flutter/material.dart';

/// Labelled rule between the primary call-to-action and the social providers.
///
/// The label also gives the logo-only buttons underneath their verbal context,
/// so it is not decorative — keep it meaningful.
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
              // Without a cap the label is laid out unconstrained between the
              // two rules and runs off the row at large text scales.
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
