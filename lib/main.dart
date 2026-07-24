import 'package:cardifly/config/provider_manager.dart';
import 'package:cardifly/config/router_manager.dart' as router;
import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/core/viewmodels/local_view_model.dart';
import 'package:cardifly/core/viewmodels/theme_model.dart';
import 'package:cardifly/generated/l10n.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) Provider.debugCheckInvalidValueType = null;

  await StorageManager.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (defaultTargetPlatform == TargetPlatform.android) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Constants.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (context, themeModel, localeModel, _) {
          return OverlaySupport.global(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: Constants.appName,
              theme: themeModel.themeData(),
              darkTheme: themeModel.themeData(platformDarkMode: true),
              themeMode: themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
              navigatorKey: NavigationService.navigatorKey,
              locale: localeModel.locale,
              initialRoute: router.RouteName.home,
              onGenerateRoute: router.RouterConfig.generateRoute,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}

class NavigationService {
  const NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
