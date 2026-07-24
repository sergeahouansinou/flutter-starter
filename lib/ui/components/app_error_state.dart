import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Compact error state with an inline retry action.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = 'Une erreur est survenue',
    this.message,
    this.onRetry,
    this.retryLabel = 'Réessayer',
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(context).textTheme.displaySmall?.color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withValues(alpha: 0.08),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 22,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, height: 1.4, color: subtle),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text(
                  retryLabel,
                  style: const TextStyle(fontSize: 12),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Constants.appPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
