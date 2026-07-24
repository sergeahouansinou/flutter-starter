import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:cardifly/ui/components/app_loader.dart';
import 'package:flutter/material.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.positiveButtonText,
    required this.negativeButtonText,
    required this.onPositive,
    required this.onNegative,
    this.positiveBtnColor = Colors.redAccent,
    this.isLoading = false,
    this.icon = Icons.help_outline_rounded,
  });

  final String title;
  final String message;
  final Color positiveBtnColor;
  final String positiveButtonText;
  final String negativeButtonText;
  final VoidCallback onPositive;
  final VoidCallback onNegative;
  final bool isLoading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: positiveBtnColor.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: positiveBtnColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Theme.of(context).textTheme.displaySmall?.color,
              ),
            ),
            const SizedBox(height: 14),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(4),
                child: AppLoader(size: 6),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AppButtonWidget(
                      title: negativeButtonText,
                      onPressed: onNegative,
                      backgroundColor:
                          Colors.grey.withValues(alpha: 0.15),
                      labelColor: Colors.black87,
                      small: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButtonWidget(
                      title: positiveButtonText,
                      onPressed: onPositive,
                      backgroundColor: positiveBtnColor,
                      small: true,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
