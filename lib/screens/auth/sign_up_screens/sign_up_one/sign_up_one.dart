import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/auth_background_decoration.dart';
import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/auth_brand_header.dart';
import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/auth_divider.dart';
import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/auth_redirect_prompt.dart';
import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/register_form.dart';
import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/social_signup_row.dart';
import 'package:cardifly/ui/components/app_fade_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpOne extends StatelessWidget {
  const SignUpOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackgroundDecoration(),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 130, 20, 20),
            child: Column(
              children: [
                const AppFadeIn(
                  child: AuthBrandHeader(subtitle: 'Create your account.'),
                ),
                const SizedBox(height: 32),
                const AppFadeIn(
                  delay: Duration(milliseconds: 120),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Inscription',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppFadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: RegisterForm(
                    onSubmit: _onSubmit,
                    onTerms: () {},
                    onPrivacy: () {},
                  ),
                ),
                const SizedBox(height: 30),
                const AppFadeIn(
                  delay: Duration(milliseconds: 300),
                  child: AuthDivider(label: 'or sign up with'),
                ),
                const SizedBox(height: 30),
                AppFadeIn(
                  delay: const Duration(milliseconds: 380),
                  child: SocialSignUpRow(
                    onFacebook: () {},
                    onGoogle: () {},
                    onApple: () {},
                  ),
                ),
                const SizedBox(height: 30),
                AppFadeIn(
                  delay: const Duration(milliseconds: 460),
                  child: AuthRedirectPrompt(
                    question: 'Already have an account ?',
                    actionLabel: 'Sign In',
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Icon(CupertinoIcons.arrow_left),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit(String fullName, String email, String password) {
    // TODO: branch the real registration call here.
  }
}
