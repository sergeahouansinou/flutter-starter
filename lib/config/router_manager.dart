import 'package:cardifly/anims/page_route_anim.dart';
import 'package:cardifly/screens/auth/sign_in_screens/sign_one/login_one.dart';
import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/sign_up_one.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/onboarding_one.dart';
import 'package:cardifly/screens/welcome/welcome_one/welcome_one.dart';
import 'package:flutter/material.dart';

class RouteName {
  RouteName._();

  static const String welcomeTwo = '/welcomeTwo';
  static const String loginOne = '/login-one';
  static const String signUpOne = '/sign-up-one';
  static const String onboardingOne = '/onboarding-one';
}

class RouterConfig {
  RouterConfig._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.onboardingOne:
        // Only ever replaced (by the welcome screen), never pushed over.
        return _root(const OnboardingOne(), settings);
      case RouteName.loginOne:
        return _forward(const LoginOne(), settings);
      case RouteName.signUpOne:
        return _forward(const SignUpOne(), settings);
      case RouteName.welcomeTwo:
      default:
        // The hub, and the fallback for unknown names: sign in is pushed on
        // top of it, so it has to drift left rather than recede.
        return _root(
          const WelcomeTwo(),
          settings,
          coveredBy: AppRouteDirection.fromRight,
        );
    }
  }

  /// A screen that replaces the stack — reached with `pushReplacementNamed` or
  /// `pushAndRemoveUntil`, so there is nothing to pop back to.
  ///
  /// Cross-fades on purpose: a slide would promise a way back that the stack
  /// can no longer honour.
  ///
  /// [coveredBy] is the direction of whatever gets pushed on top of it later:
  /// without it the page recedes in Z while the incoming one travels sideways,
  /// which reads as two effects fighting.
  static Route<dynamic> _root(
    Widget page,
    RouteSettings settings, {
    AppRouteDirection? coveredBy,
  }) {
    return AppPageRoute<dynamic>(
      page,
      direction: AppRouteDirection.none,
      parallaxDirection: coveredBy,
      settings: settings,
    );
  }

  /// A screen pushed on top of another one — poppable, so it slides in from the
  /// right and the page underneath drifts left. `pop()` replays it backwards.
  static Route<dynamic> _forward(Widget page, RouteSettings settings) {
    return AppPageRoute<dynamic>(
      page,
      settings: settings,
    );
  }
}
