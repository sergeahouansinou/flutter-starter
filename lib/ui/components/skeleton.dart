import 'package:cardifly/ui/components/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Miniature rectangular placeholder block with shimmer.
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.radius = 6,
    this.animated = true,
  });

  final double? height;
  final double? width;
  final double radius;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final block = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return animated ? AppShimmer(child: block) : block;
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({super.key, this.size = 18, this.animated = true});

  final double size;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final block = Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.06),
        shape: BoxShape.circle,
      ),
    );
    return animated ? AppShimmer(child: block) : block;
  }
}

/// N-line skeleton stack — miniature spacing/heights.
class SkeletonTextBlock extends StatelessWidget {
  const SkeletonTextBlock({
    super.key,
    this.lines = 2,
    this.spacing = 5,
    this.firstLineWidthFactor = 0.6,
    this.lineHeight = 8,
  });

  final int lines;
  final double spacing;
  final double firstLineWidthFactor;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lines, (i) {
            final isLast = i == lines - 1;
            final factor = i == 0
                ? firstLineWidthFactor
                : isLast
                ? 0.35
                : 1.0;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
              child: Skeleton(
                width: constraints.maxWidth * factor,
                height: lineHeight,
                radius: 3,
              ),
            );
          }),
        );
      },
    );
  }
}
