import 'package:cardifly/ui/components/skeleton.dart';
import 'package:flutter/material.dart';

/// Compact skeleton list used for initial-load states.
class AppListSkeleton extends StatelessWidget {
  const AppListSkeleton({
    super.key,
    this.itemCount = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.itemBuilder,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;
  final IndexedWidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: itemBuilder ?? _defaultRow,
    );
  }

  Widget _defaultRow(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: const Row(
        children: [
          CircleSkeleton(size: 32),
          SizedBox(width: 10),
          Expanded(
            child: SkeletonTextBlock(
              lines: 2,
              firstLineWidthFactor: 0.5,
            ),
          ),
          SizedBox(width: 8),
          Skeleton(width: 32, height: 16, radius: 8),
        ],
      ),
    );
  }
}
