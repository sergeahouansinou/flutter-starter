import 'package:cardifly/config/router_manager.dart';
import 'package:cardifly/screens/welcome/welcome_one/_partials/social_auth_buttons.dart';
import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_divider.dart';
import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_footer_prompt.dart';
import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_hero.dart';
import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_legal_notice.dart';
import 'package:cardifly/screens/welcome/welcome_one/_partials/welcome_palette.dart';
import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:cardifly/ui/components/app_fade_in.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeTwo extends StatelessWidget {
  const WelcomeTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = WelcomePalette.of(context);
    final animate = !MediaQuery.disableAnimationsOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: palette.isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final illustrationHeight = (constraints.maxHeight * 0.2)
                      .clamp(100.0, 180.0);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 80,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: AppFadeIn.stagger(animate: animate, [
                          WelcomeHero(
                            eyebrow: 'Passez au niveau supérieur',
                            title: 'Bienvenue sur ${Constants.appName}',
                            subtitle:
                                'Nous vous présentons la nouvelle version '
                                'de notre application avec code source.',
                            illustrationHeight: illustrationHeight,
                          ),
                          const SizedBox(height: 32),
                          AppButtonWidget(
                            radius: 14,
                            title: 'Continuer avec E-mail',
                            icon: CupertinoIcons.envelope_fill,
                            backgroundColor: palette.accent,
                            labelColor: palette.onAccent,
                            iconColor: palette.onAccent,
                            onPressed: () => _onEmail(context),
                          ),
                          const SizedBox(height: 20),
                          const WelcomeDivider(label: 'ou continuer avec'),
                          const SizedBox(height: 20),
                          SocialAuthButtons(
                            onGoogle: _onGoogle,
                            onApple: _onApple,
                            onFacebook: _onFacebook,
                          ),
                          const SizedBox(height: 24),
                          WelcomeLegalNotice(
                            onTerms: _onTerms,
                            onPrivacy: _onPrivacy,
                          ),
                          const SizedBox(height: 12),
                          WelcomeFooterPrompt(
                            question: 'Déjà un compte ?',
                            actionLabel: 'Connectez-vous !',
                            onTap: () => _onSignIn(context),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: _CloseButton(
                  color: palette.foreground,
                  onPressed: () => _onClose(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEmail(BuildContext context) =>
      Navigator.pushNamed(context, RouteName.loginOne);

  void _onSignIn(BuildContext context) =>
      Navigator.pushNamed(context, RouteName.loginOne);

  void _onClose(BuildContext context) =>
      Navigator.pushReplacementNamed(context, RouteName.onboardingOne);

  void _onGoogle() {
    // TODO: branch the Google sign-in call here.
  }

  void _onApple() {
    // TODO: branch the Apple sign-in call here.
  }

  void _onFacebook() {
    // TODO: branch the Facebook sign-in call here.
  }

  void _onTerms() {
    // TODO: open the terms of service.
  }

  void _onPrivacy() {
    // TODO: open the privacy policy.
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.color, required this.onPressed});

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Fermer et revenir à la présentation',
      child: InkResponse(
        onTap: onPressed,
        radius: 24,
        child: SizedBox.square(
          dimension: 44,
          child: Icon(
            CupertinoIcons.xmark,
            size: 20,
            color: color.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
