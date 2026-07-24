import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Compact empty state widget with a small halo icon.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.title = 'Aucune donnée',
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

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
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Constants.appPrimaryColor.withValues(alpha: 0.18),
                    Constants.appPrimaryColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Constants.appPrimaryColor.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 4),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, height: 1.4, color: subtle),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text(
                  actionLabel!,
                  style: const TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Constants.appPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          Constants.appPrimaryColor.withValues(alpha: 0.35),
                    ),
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
