import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.assetPath,
    this.onTap,
    this.size = 30,
  });

  final String assetPath;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(assetPath, width: size, height: size),
        ),
      ),
    );
  }
}
