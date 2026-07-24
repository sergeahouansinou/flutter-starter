import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/helper/theme_helper.dart';
import 'package:cardifly/ui/theme/app_text.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  static const _kUserDarkMode = 'kThemeUserDarkMode';

  bool _userDarkMode = false;

  ThemeModel() {
    _userDarkMode =
        StorageManager.sharedPreferences?.getBool(_kUserDarkMode) ?? false;
  }

  bool get isDark => _userDarkMode;

  Future<void> switchTheme({bool? userDarkMode}) async {
    _userDarkMode = userDarkMode ?? !_userDarkMode;
    notifyListeners();
    await StorageManager.sharedPreferences?.setBool(
      _kUserDarkMode,
      _userDarkMode,
    );
  }

  ThemeData themeData({bool platformDarkMode = false}) {
    final isDark = platformDarkMode || _userDarkMode;
    final brightness = isDark ? Brightness.dark : Brightness.light;

    final scaffoldBg =
        isDark ? Constants.appDarkScaffold : Constants.scaffoldBackgroundColor;
    final cardColor = isDark ? Constants.appDarkCardColor : Colors.white;
    final onSurface = isDark ? Colors.white : const Color(0xFF14181F);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: Constants.appPrimaryColor,
      brightness: brightness,
      primary: Constants.appPrimaryColor,
      secondary: Constants.appSecondaryColor,
      surface: scaffoldBg,
      error: Colors.redAccent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: cardColor,
      fontFamily: 'Poppins',
      visualDensity: VisualDensity.compact,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: AppTextTheme.textThemeFor(onSurface),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: Constants.appPrimaryColor,
        brightness: brightness,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scaffoldBg,
        surfaceTintColor: scaffoldBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: onSurface.withValues(alpha: 0.05)),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        backgroundColor: scaffoldBg,
        foregroundColor: onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontFamily: 'Poppins',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: onSurface, size: 18),
      ),
      iconTheme: IconThemeData(color: onSurface, size: 18),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Constants.appPrimaryColor,
          minimumSize: const Size(0, 32),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.appPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 34),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Constants.appPrimaryColor,
          minimumSize: const Size(0, 34),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: Constants.appPrimaryColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Constants.appPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        sizeConstraints: BoxConstraints.tightFor(width: 44, height: 44),
        iconSize: 20,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Constants.appPrimaryColor.withValues(alpha: 0.12),
        labelStyle: const TextStyle(
          fontSize: 11,
          color: Constants.appPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        side: BorderSide.none,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Constants.appPrimaryColor,
        unselectedLabelColor: onSurface.withValues(alpha: 0.55),
        indicatorColor: Constants.appPrimaryColor,
        dividerColor: onSurface.withValues(alpha: 0.06),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      dividerTheme: DividerThemeData(
        color: onSurface.withValues(alpha: 0.08),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(isDark: isDark),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Constants.appPrimaryColor,
        selectionColor:
            Constants.appPrimaryColor.withValues(alpha: 0.25),
        selectionHandleColor: Constants.appPrimaryColor,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cardColor,
        surfaceTintColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scaffoldBg,
        surfaceTintColor: scaffoldBg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
    );
  }
}
