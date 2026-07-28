import 'package:cardifly/config/router_manager.dart' as router;
import 'package:cardifly/core/viewmodels/theme_model.dart';
import 'package:cardifly/screens/welcome/welcome_one/welcome_one.dart';
import 'package:flutter/material.dart';

void main() => runApp(const W());

class W extends StatelessWidget {
  const W({super.key});
  @override
  Widget build(BuildContext context) {
    final m = ThemeModel();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: m.themeData(),
      darkTheme: m.themeData(platformDarkMode: true),
      themeMode: ThemeMode.system,
      onGenerateRoute: router.RouterConfig.generateRoute,
      home: const WelcomeTwo(),
    );
  }
}
