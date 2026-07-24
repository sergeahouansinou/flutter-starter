import 'dart:math' as math;

import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// Compact "typing dots" loader: three bouncing dots reminiscent of an
/// iMessage / WhatsApp typing indicator. Small by default and reusable
/// everywhere in the app.
class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.size = 18,
    this.color,
    this.label,
    this.spacing = 3,
  });

  final double size;
  final Color? color;
  final String? label;
  final double spacing;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Constants.appPrimaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              size: Size(widget.size * 3 + widget.spacing * 2, widget.size),
              painter: _TypingDotsPainter(
                progress: _controller.value,
                color: color,
                spacing: widget.spacing,
              ),
            ),
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.displaySmall?.color,
            ),
          ),
        ],
      ],
    );
  }
}

class _TypingDotsPainter extends CustomPainter {
  _TypingDotsPainter({
    required this.progress,
    required this.color,
    required this.spacing,
  });

  final double progress;
  final Color color;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    const dotCount = 3;
    final radius = size.height / 2;
    final centerY = size.height / 2;

    for (var i = 0; i < dotCount; i++) {
      final phase = (progress - i * 0.15) % 1.0;
      final wave = math.sin(phase * math.pi).clamp(0.0, 1.0);
      final alpha = 0.35 + 0.65 * wave;
      final scale = 0.75 + 0.25 * wave;

      final cx = radius + i * (size.height + spacing);
      final paint = Paint()..color = color.withValues(alpha: alpha);
      canvas.drawCircle(Offset(cx, centerY), radius * scale, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TypingDotsPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// Compact centered loader — used for busy screens.
class AppLoaderCentered extends StatelessWidget {
  const AppLoaderCentered({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(child: AppLoader(size: 8, label: label));
  }
}
