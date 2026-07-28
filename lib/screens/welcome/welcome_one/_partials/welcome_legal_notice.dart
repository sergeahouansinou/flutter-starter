import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Consent line shown under the sign-in options.
///
/// Stateful only because the two spans own [TapGestureRecognizer]s, which have
/// to be disposed.
class WelcomeLegalNotice extends StatefulWidget {
  const WelcomeLegalNotice({
    super.key,
    required this.onTerms,
    required this.onPrivacy,
  });

  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  State<WelcomeLegalNotice> createState() => _WelcomeLegalNoticeState();
}

class _WelcomeLegalNoticeState extends State<WelcomeLegalNotice> {
  final _terms = TapGestureRecognizer();
  final _privacy = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _terms.onTap = () => widget.onTerms();
    _privacy.onTap = () => widget.onPrivacy();
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = WelcomePalette.of(context);
    final base = AppTextStyle.bodySm(color: palette.muted);
    final link = AppTextStyle.bodySm(color: palette.accent).copyWith(
      fontWeight: AppFontWeight.semibold,
    );

    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: 'En continuant, vous acceptez nos ',
        style: base,
        children: [
          TextSpan(
            text: "conditions d'utilisation",
            style: link,
            recognizer: _terms,
          ),
          TextSpan(text: ' et notre ', style: base),
          TextSpan(
            text: 'politique de confidentialité',
            style: link,
            recognizer: _privacy,
          ),
          TextSpan(text: '.', style: base),
        ],
      ),
    );
  }
}
