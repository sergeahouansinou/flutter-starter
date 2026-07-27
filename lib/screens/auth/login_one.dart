import 'package:cardifly/screens/auth/_partials/auth_background_decoration.dart';
import 'package:cardifly/screens/auth/_partials/auth_brand_header.dart';
import 'package:cardifly/screens/auth/_partials/auth_divider.dart';
import 'package:cardifly/screens/auth/_partials/auth_redirect_prompt.dart';
import 'package:cardifly/screens/auth/_partials/login_form.dart';
import 'package:cardifly/screens/auth/_partials/social_login_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginOne extends StatelessWidget {
  const LoginOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackgroundDecoration(),
          Positioned(
            top: 70,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Icon(CupertinoIcons.arrow_left),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 130, 20, 20),
            child: Column(
              children: [
                const AuthBrandHeader(subtitle: 'Sign in to your account.'),
                const Spacer(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LoginForm(
                  onSubmit: _onSubmit,
                  onForgotPassword: () {},
                ),
                const SizedBox(height: 40),
                const AuthDivider(label: 'or continue with'),
                const SizedBox(height: 40),
                SocialLoginRow(
                  onFacebook: () {},
                  onGoogle: () {},
                  onApple: () {},
                ),
                const SizedBox(height: 40),
                AuthRedirectPrompt(
                  question: "Don't have an account ?",
                  actionLabel: 'Sign Up',
                  onTap: () {},
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _onSubmit(String email, String password) {
    // TODO: branch the real authentication call here.
  }
}
