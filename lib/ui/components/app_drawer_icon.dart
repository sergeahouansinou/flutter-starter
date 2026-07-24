import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Custom drawer trigger icon (replaces the default hamburger).
/// Two staggered rounded bars + an accent dot at the top-right.
class AppDrawerIcon extends StatelessWidget {
  const AppDrawerIcon({
    super.key,
    this.color,
    this.accentColor = Constants.appPrimaryColor,
    this.size = 20,
    this.onTap,
    this.tooltip = 'Menu',
  });

  final Color? color;
  final Color accentColor;
  final double size;
  final VoidCallback? onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final barColor =
        color ?? Theme.of(context).iconTheme.color ?? Colors.black87;
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: size,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: CustomPaint(
            size: Size(size, size),
            painter: _DrawerIconPainter(
              barColor: barColor,
              accentColor: accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerIconPainter extends CustomPainter {
  _DrawerIconPainter({required this.barColor, required this.accentColor});

  final Color barColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = barColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Top bar (75% width, slightly offset right)
    canvas.drawLine(
      Offset(w * 0.15, h * 0.28),
      Offset(w * 0.75, h * 0.28),
      barPaint,
    );

    // Middle bar (full width)
    canvas.drawLine(
      Offset(w * 0.15, h * 0.52),
      Offset(w * 0.85, h * 0.52),
      barPaint,
    );

    // Bottom bar (55% width)
    canvas.drawLine(
      Offset(w * 0.15, h * 0.76),
      Offset(w * 0.55, h * 0.76),
      barPaint,
    );

    // Accent dot in the top-right corner
    canvas.drawCircle(
      Offset(w * 0.86, h * 0.28),
      2.4,
      Paint()..color = accentColor,
    );
  }

  @override
  bool shouldRepaint(covariant _DrawerIconPainter old) =>
      old.barColor != barColor || old.accentColor != accentColor;
}
