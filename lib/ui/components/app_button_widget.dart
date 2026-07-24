import 'package:cardifly/ui/components/app_loader.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Compact primary button.
class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 36,
    this.enabled = true,
    this.loading = false,
    this.backgroundColor = Constants.appPrimaryColor,
    this.borderColor,
    this.iconColor,
    this.labelColor = Colors.white,
    this.small = false,
    this.radius = 10,
  });

  final String title;
  final VoidCallback onPressed;
  final bool loading;
  final Color? iconColor;
  final double? width;
  final Color backgroundColor;
  final Color? borderColor;
  final Color labelColor;
  final IconData? icon;
  final bool enabled;
  final double height;
  final bool small;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = !enabled
        ? Colors.grey.shade400
        : loading
            ? backgroundColor.withValues(alpha: 0.75)
            : backgroundColor;

    return SizedBox(
      width: width ?? double.infinity,
      height: small ? 30 : height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderColor != null ? 1.2 : 0,
          ),
          gradient: enabled && !loading
              ? LinearGradient(
                  colors: [
                    backgroundColor,
                    backgroundColor.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: enabled && !loading ? null : effectiveBg,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: !loading && enabled ? onPressed : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: small ? 8 : 14,
                vertical: small ? 4 : 6,
              ),
              child: Center(
                child: loading
                    ? AppLoader(size: small ? 4 : 5, color: labelColor)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              size: small ? 12 : 15,
                              color: iconColor ?? labelColor,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: small ? 11 : 13,
                                color: labelColor,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
