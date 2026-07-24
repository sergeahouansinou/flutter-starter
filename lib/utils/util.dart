import 'dart:convert';

import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/core/models/user.dart';
import 'package:cardifly/core/viewmodels/local_view_model.dart';
import 'package:cardifly/core/viewmodels/theme_model.dart';
import 'package:cardifly/main.dart';
import 'package:cardifly/ui/components/app_loader.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:cardifly/utils/types/feedback_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  Util._();

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static void switchDarkMode(BuildContext context) {
    context.read<ThemeModel>().switchTheme(
      userDarkMode: Theme.of(context).brightness == Brightness.light,
    );
  }

  /// Custom-branded inline loader that replaces the default
  /// CircularProgressIndicator / CupertinoActivityIndicator.
  static Widget circularIndicator({
    BuildContext? context,
    Color? color,
    String? label,
    double size = 24,
  }) {
    return AppLoader(size: size, color: color, label: label);
  }

  // ---------------------------------------------------------------------------
  // Validators
  // ---------------------------------------------------------------------------

  static String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir un mot de passe';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    return null;
  }

  static String? fieldValidate(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ce champ est requis';
    return null;
  }

  static String? passwordConfValidate(
    String? password,
    String? value, {
    String? text,
  }) {
    if (value != password) {
      return text ?? 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    return _urlPattern.hasMatch(value)
        ? null
        : 'Veuillez saisir un lien valide';
  }

  static final _urlPattern = RegExp(
    r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
  );

  static String? requireAndValidateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est requis';
    return _emailPattern.hasMatch(value)
        ? null
        : 'Veuillez saisir une adresse email valide';
  }

  static String? validateEmailFormat(String? value) {
    if (value == null || value.isEmpty) return null;
    return _emailPattern.hasMatch(value)
        ? null
        : 'Veuillez saisir une adresse email valide';
  }

  static final _emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  // ---------------------------------------------------------------------------
  // Storage helpers
  // ---------------------------------------------------------------------------

  static String? getToken() {
    return StorageManager.sharedPreferences?.getString(Constants.kToken);
  }

  static User? getUserInfo() {
    final userStr =
        StorageManager.sharedPreferences?.getString(Constants.kUserInfo);
    if (userStr == null) return null;
    return User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
  }

  static String? getLanguage() {
    final index = StorageManager.sharedPreferences?.getInt(
      Constants.kLocaleIndex,
    );
    switch (index) {
      case 0:
        return 'fr';
      case 1:
        return 'en';
      default:
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Formatting
  // ---------------------------------------------------------------------------

  static String formatAmount(num amount, String currencyCode) {
    final locale = getLanguage() ?? 'fr';
    return NumberFormat.currency(locale: locale, name: currencyCode)
        .format(amount);
  }

  static String formatDate(DateTime date) {
    final localeCode =
        NavigationService.navigatorKey.currentContext
                ?.read<LocaleModel>()
                .localeString ??
            'fr';
    return DateFormat('dd MMMM yyyy', localeCode).format(date);
  }

  static String formatDateForApi(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static String formatDateToMonth(DateTime date, {String locale = 'fr_FR'}) {
    final formatted = DateFormat('MMMM yyyy', locale).format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  static String datetimeToVerboseDate(BuildContext context, DateTime date) {
    final locale = context.read<LocaleModel>().localeString == 'fr'
        ? 'fr_FR'
        : 'en_US';
    return DateFormat.yMMMMd(locale).format(date);
  }

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String formatCurrency(String amount) {
    return NumberFormat.currency(
      symbol: 'FCFA',
      locale: 'fr',
      decimalDigits: 0,
    ).format(double.parse(amount));
  }

  // ---------------------------------------------------------------------------
  // Dialogs & notifications
  // ---------------------------------------------------------------------------

  static Future<void> showSimpleDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String negativeText,
    required String positiveText,
    required VoidCallback negativeAction,
    required VoidCallback positiveAction,
    Color? titleColor,
    Color negativeActionColor = Colors.grey,
    Color positiveActionColor = Colors.green,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: titleColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(content, style: const TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: negativeAction,
            child: Text(
              negativeText,
              style: TextStyle(color: negativeActionColor),
            ),
          ),
          TextButton(
            onPressed: positiveAction,
            child: Text(
              positiveText,
              style: TextStyle(color: positiveActionColor),
            ),
          ),
        ],
      ),
    );
  }

  static void displayNotification({
    required String message,
    Color messageColor = Colors.white,
    FeedbackType type = FeedbackType.success,
    NotificationPosition position = NotificationPosition.top,
  }) {
    showSimpleNotification(
      Text(message, style: TextStyle(color: messageColor)),
      leading: Icon(_iconFor(type), color: Colors.white),
      slideDismissDirection:
          isIOS ? DismissDirection.up : DismissDirection.startToEnd,
      position: position,
      background: _colorFor(type),
    );
  }

  static IconData _iconFor(FeedbackType type) {
    switch (type) {
      case FeedbackType.info:
        return Icons.info_outline_rounded;
      case FeedbackType.success:
        return Icons.check_circle_outline_rounded;
      case FeedbackType.warning:
        return Icons.warning_amber_rounded;
      case FeedbackType.error:
        return Icons.error_outline_rounded;
    }
  }

  static Color _colorFor(FeedbackType type) {
    switch (type) {
      case FeedbackType.info:
        return Colors.blueAccent;
      case FeedbackType.success:
        return Colors.green;
      case FeedbackType.warning:
        return Colors.orange;
      case FeedbackType.error:
        return Colors.redAccent;
    }
  }

  // ---------------------------------------------------------------------------
  // Sharing
  // ---------------------------------------------------------------------------

  static Future<void> shareWithFile(
    XFile file,
    String text, {
    String? subject,
  }) async {
    final fullText =
        '$text\n\nPlaystore : ${Constants.playstoreUrl}\nApp Store: ${Constants.appleStoreUrl}';
    await SharePlus.instance.share(
      ShareParams(text: fullText, subject: subject, files: [file]),
    );
  }

  static Future<void> share(String text, {String? subject}) async {
    final fullText =
        '$text\n\nPlaystore : ${Constants.playstoreUrl}\nApp Store: ${Constants.appleStoreUrl}';
    await SharePlus.instance.share(
      ShareParams(text: fullText, subject: subject),
    );
  }

  static Future<void> shareApp() async {
    final url = isIOS ? Constants.appleStoreUrl : Constants.playstoreUrl;
    await SharePlus.instance.share(
      ShareParams(text: 'Découvrez ${Constants.appName} : $url'),
    );
  }

  // ---------------------------------------------------------------------------
  // URL launching
  // ---------------------------------------------------------------------------

  static Future<void> launchMyUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------

  static double drawerWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < 650 ? width * 0.85 : width * 0.45;
  }

  static List<PopupMenuEntry<String>> get menuItems => const [
    PopupMenuItem<String>(
      value: 'mask',
      child: Row(
        children: [
          Icon(CupertinoIcons.eye_slash, size: 18, color: Colors.grey),
          SizedBox(width: 8),
          Text('Masquer'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'edit',
      child: Row(
        children: [
          Icon(Icons.edit, size: 18, color: Colors.grey),
          SizedBox(width: 8),
          Text('Modifier'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, size: 18, color: Colors.red),
          SizedBox(width: 8),
          Text('Supprimer'),
        ],
      ),
    ),
  ];
}

