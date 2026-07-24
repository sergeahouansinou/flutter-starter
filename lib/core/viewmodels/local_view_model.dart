import 'dart:io';

import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocaleModel extends ChangeNotifier {
  static const List<String> localeValueList = ['fr', 'en'];

  int _localeIndex = 0;

  LocaleModel() {
    _localeIndex =
        StorageManager.sharedPreferences?.getInt(Constants.kLocaleIndex) ?? 0;
  }

  int get localeIndex => _localeIndex;

  Locale get locale {
    if (_localeIsNotChosen()) {
      final platformLocale =
          (kIsWeb ? 'fr' : Platform.localeName).split('_').first;
      final index = localeValueList.indexOf(platformLocale);
      switchLocale(index == -1 ? 0 : index);
    }
    return Locale(localeValueList[_localeIndex]);
  }

  String get localeString => localeValueList[_localeIndex];

  bool _localeIsNotChosen() =>
      StorageManager.sharedPreferences?.getInt(Constants.kLocaleIndex) == null;

  Future<void> switchLocale(int index) async {
    _localeIndex = index;
    await StorageManager.sharedPreferences?.setInt(
      Constants.kLocaleIndex,
      _localeIndex,
    );
    notifyListeners();
  }

  String localeName(int index) {
    switch (index) {
      case 0:
        return 'Français';
      case 1:
        return 'English';
      default:
        return '';
    }
  }
}
