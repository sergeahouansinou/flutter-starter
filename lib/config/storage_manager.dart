import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Central access point for local persistence.
///
/// Call [init] once (from `main`) before touching any of the static
/// members. All fields are nullable so tests can bypass the real
/// initialization when needed.
class StorageManager {
  StorageManager._();

  static SharedPreferences? sharedPreferences;
  static Directory? temporaryDirectory;
  static LocalStorage? localStorage;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      await initLocalStorage();
    } catch (_) {
      // localstorage relies on path_provider; ignore in unsupported hosts.
    }
    try {
      temporaryDirectory = await getTemporaryDirectory();
    } catch (_) {
      // No-op on platforms without a temp dir (unusual, but tolerated).
    }
  }
}
