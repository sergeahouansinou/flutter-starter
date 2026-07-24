import 'package:cardifly/anims/page_route_anim.dart';

import 'package:cardifly/screens/home_two/home_two.dart';
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
        return NoAnimRouteBuilder(const HomeTwo());
      default:
        return NoAnimRouteBuilder(const HomeTwo());
    }
  }
}
