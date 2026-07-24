import 'package:cardifly/anims/page_route_anim.dart';
import 'package:cardifly/screens/home_one/home_screen.dart';
import 'package:flutter/material.dart';

class RouteName {
  RouteName._();

  static const String home = '/';
}

class RouterConfig {
  RouterConfig._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return NoAnimRouteBuilder(const HomeScreen());
      default:
        return NoAnimRouteBuilder(const HomeScreen());
    }
  }
}
