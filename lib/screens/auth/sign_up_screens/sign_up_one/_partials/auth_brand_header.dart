import 'package:cardifly/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.creditcard_fill,
              size: 35,
              color: Constants.appPrimaryColor,
            ),
            Text(
              'CardiFly',
              style: TextStyle(
                fontSize: 35,
                color: Constants.appPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
