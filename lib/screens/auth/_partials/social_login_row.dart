import 'package:cardifly/screens/auth/_partials/social_icon_button.dart';
import 'package:flutter/material.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({
    super.key,
    this.onFacebook,
    this.onGoogle,
    this.onApple,
  });

  final VoidCallback? onFacebook;
  final VoidCallback? onGoogle;
  final VoidCallback? onApple;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        SocialIconButton(
          assetPath: 'assets/svg/facebook.svg',
          onTap: onFacebook,
        ),
        SocialIconButton(
          assetPath: 'assets/svg/google.svg',
          onTap: onGoogle,
        ),
        SocialIconButton(
          assetPath: 'assets/svg/apple.svg',
          onTap: onApple,
        ),
      ],
    );
  }
}
