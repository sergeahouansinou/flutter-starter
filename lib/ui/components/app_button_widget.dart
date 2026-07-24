import 'package:cardifly/ui/components/app_loader.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

/// Compact primary button.
///
/// The leading glyph accepts either a Material [icon] or an [svgIcon] asset
/// path (e.g. `assets/svg/google.svg`) — never both.
class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.svgIcon,
    this.iconSize,
    this.width,
    this.height = 36,
    this.enabled = false,
    this.loading = false,
    this.backgroundColor = Constants.appPrimaryColor,
    this.borderColor,
    this.iconColor,
    this.labelColor = Colors.white,
    this.small = false,
    this.radius = 10,
  }) : assert(
         icon == null || svgIcon == null,
         'Provide either `icon` or `svgIcon`, not both.',
       );

  final String title;
  final VoidCallback onPressed;
  final bool loading;
  final Color? iconColor;
  final double? width;
  final Color backgroundColor;
  final Color? borderColor;
  final Color labelColor;
  final IconData? icon;

  /// Asset path of an SVG to use as the leading glyph, instead of [icon].
  final String? svgIcon;

  /// Overrides the default glyph size (12 when [small], 15 otherwise).
  final double? iconSize;

  final bool enabled;
  final double height;
  final bool small;
  final double radius;

  /// Leading glyph, or `null` when neither [icon] nor [svgIcon] is set.
  ///
  /// An [svgIcon] keeps its own colours unless [iconColor] is provided, so
  /// multicolour brand logos (Google, Facebook…) render untouched while
  /// monochrome pictograms can still be tinted to match [labelColor].
  Widget? get _glyph {
    final size = iconSize ?? (small ? 12.0 : 15.0);

    if (svgIcon != null) {
      return SvgPicture.asset(
        svgIcon!,
        width: size,
        height: size,
        colorFilter: iconColor == null
            ? null
            : ColorFilter.mode(iconColor!, BlendMode.srcIn),
      );
    }

    if (icon != null) {
      return Icon(icon, size: size, color: iconColor ?? labelColor);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final glyph = _glyph;
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
          gradient: !enabled && !loading
              ? LinearGradient(
                  colors: [
                    backgroundColor,
                    backgroundColor.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !enabled && !loading ? null : effectiveBg,
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
                          if (glyph != null) ...[
                            glyph,
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
