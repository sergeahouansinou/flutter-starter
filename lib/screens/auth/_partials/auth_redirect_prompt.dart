import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthRedirectPrompt extends StatefulWidget {
  const AuthRedirectPrompt({
    super.key,
    required this.question,
    required this.actionLabel,
    this.onTap,
  });

  final String question;
  final String actionLabel;
  final VoidCallback? onTap;

  @override
  State<AuthRedirectPrompt> createState() => _AuthRedirectPromptState();
}

class _AuthRedirectPromptState extends State<AuthRedirectPrompt> {
  final _recognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _recognizer.onTap = widget.onTap;

    return RichText(
      text: TextSpan(
        text: '${widget.question} ',
        style: const TextStyle(color: Colors.black45),
        children: [
          TextSpan(
            text: widget.actionLabel,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
            recognizer: widget.onTap == null ? null : _recognizer,
          ),
        ],
      ),
    );
  }
}
