import 'package:cardifly/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTerms,
    this.onPrivacy,
    this.errorText,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;

  /// Shown under the row when the box is required but still unchecked.
  final String? errorText;

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  final _termsRecognizer = TapGestureRecognizer();
  final _privacyRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _termsRecognizer.onTap = widget.onTerms;
    _privacyRecognizer.onTap = widget.onPrivacy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBox(),
            const SizedBox(width: 10),
            Expanded(child: _buildLabel()),
          ],
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 28),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildBox() {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 18,
        width: 18,
        decoration: BoxDecoration(
          color: widget.value
              ? Constants.appPrimaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: widget.value
                ? Constants.appPrimaryColor
                : Colors.grey.withValues(alpha: 0.5),
            width: 1.4,
          ),
        ),
        child: widget.value
            ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildLabel() {
    const linkStyle = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    return RichText(
      text: TextSpan(
        text: 'I agree to the ',
        style: const TextStyle(color: Colors.black45, fontSize: 12),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: widget.onTerms == null ? null : _termsRecognizer,
          ),
          const TextSpan(text: ' and the '),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: widget.onPrivacy == null ? null : _privacyRecognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
