import 'package:flutter/cupertino.dart';

class NoAnimRouteBuilder<T> extends PageRouteBuilder<T> {
  NoAnimRouteBuilder(this.page)
      : super(
          opaque: false,
          pageBuilder: (_, _, _) => page,
          transitionDuration: Duration.zero,
          transitionsBuilder: (_, _, _, child) => child,
        );

  final Widget page;
}

class EnterExitRoute<T> extends PageRouteBuilder<T> {
  EnterExitRoute({this.exitPage, required this.enterPage})
      : super(
          pageBuilder: (context, animation, _) => enterPage,
          transitionsBuilder: (context, animation, _, child) {
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-1.0, 0.0),
                  ).animate(animation),
                  child: exitPage,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: enterPage,
                ),
              ],
            );
          },
        );

  final Widget? exitPage;
  final Widget enterPage;
}

class KyNavigate {
  KyNavigate._();

  static PageRoute<T> slideIn<T extends Object?>(
    Widget widget, {
    String? name,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    PageRoute<Object>? hostRoute,
  }) {
    return CupertinoPageRoute<T>(
      builder: (_) => widget,
      settings: name != null ? RouteSettings(name: name) : settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static PageRoute<T> fadeIn<T extends Object?>(
    Widget widget, {
    String? name,
    RouteSettings? settings,
    bool maintainState = true,
  }) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (_, _, _) => widget,
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
      settings: name != null ? RouteSettings(name: name) : settings,
      maintainState: maintainState,
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  FadeRouteBuilder(this.page)
      : super(
          pageBuilder: (_, _, _) => page,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) => FadeTransition(
            opacity: Tween<double>(begin: 0.1, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: child,
          ),
        );

  final Widget page;
}

class SlideTopRouteBuilder<T> extends PageRouteBuilder<T> {
  SlideTopRouteBuilder(this.page)
      : super(
          pageBuilder: (_, _, _) => page,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: child,
          ),
        );

  final Widget page;
}

class SizeRoute<T> extends PageRouteBuilder<T> {
  SizeRoute(this.page)
      : super(
          pageBuilder: (_, _, _) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, animation, _, child) => ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: child,
          ),
        );

  final Widget page;
}
