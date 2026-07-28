import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final lineColor = Colors.grey.withValues(alpha: 0.2);

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
          ),
        ),
        Expanded(child: Container(height: 1, color: lineColor)),
      ],
    );
  }
}
