import 'package:cardifly/anims/page_route_anim.dart';
import 'package:cardifly/screens/auth/sign_in_screens/sign_one/login_one.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/onboarding_one.dart';
import 'package:cardifly/screens/welcome/welcome_one/welcome_one.dart';
import 'package:flutter/material.dart';

class RouteName {
  RouteName._();

  static const String welcomeTwo = '/welcomeTwo';
  static const String loginOne = '/login-one';
  static const String onboardingOne = '/onboarding-one';
}

class RouterConfig {
  RouterConfig._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.loginOne:
        return NoAnimRouteBuilder(const LoginOne());
      case RouteName.onboardingOne:
        return NoAnimRouteBuilder(const OnboardingOne());
      case RouteName.welcomeTwo:
        return NoAnimRouteBuilder(const WelcomeTwo());
      default:
        return NoAnimRouteBuilder(const WelcomeTwo());
    }
  }
}
