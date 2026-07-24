import 'package:flutter/material.dart';

class Constants {
  Constants._();

  // Preference keys
  static const kIsLogged = 'kIsLogged';
  static const kIsArtist = 'kIsArtist';
  static const kIsAccountActivated = 'kIsAccountActivated';
  static const kUserInfo = 'kUserInfo';
  static const kArtistInfo = 'kArtistInfo';
  static const kToken = 'kToken';
  static const kFavorites = 'kFavorites';
  static const kLikes = 'kLikes';
  static const kPlaylists = 'kPlaylists';
  static const kArtistsFollowedIds = 'kArtistsFollowedIds';
  static const kLocaleIndex = 'kLocaleIndex';
  static const kOnboardingAlreadySeen = 'kOnboardingAlreadySeen';
  static const kIsAuthenticatedRequest = 'kIsAuthenticatedRequest';
  static const kDrawerItemIndex = 'kDrawerItemIndex';
  static const kFcmToken = 'kFcmToken';

  // App metadata
  static const appVersion = '2.0.3';
  static const appName = 'Cardifly';
  static const authorName = 'KY SOLUTIONS';
  static const authorPhone = '+33972369052';
  static const authorEmail = 'contact@ky-solutions.fr';
  static const appStoreId = '6670394729';

  // URLs
  static const sharingDomainUrl = 'https://app.cardifly.fr/';
  static const liveBaseUrl = 'https://api-v2.cardifly.fr/';
  static const testBaseUrl = 'https://api-cardifly.ky-solutions.net/';
  static const localBaseUrl = 'http://192.168.1.115:8000/';
  static const baseUrl = localBaseUrl;

  static const kySolutionsWebsite = 'https://ky-solutions.fr';
  static const playstoreUrl =
      'https://play.google.com/store/apps/details?id=ky.solutions.cardifly';
  static const appleStoreUrl =
      'https://apps.apple.com/us/app/cardifly/id6670394729';

  // Palette
  static const Color appPrimaryColor = Color(0xFF0F70B7);
  static const Color appSecondaryColor = Color(0xFFEDD13A);
  static const Color appDarkScaffold = Color(0xFF1A2037);
  static const Color appDarkCardColor = Color(0xFF283151);
  static const Color scaffoldBackgroundColor = Color(0xFFFAFBFD);

  // Elevation presets (miniature scale)
  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  static final List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 14,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];

  // Feedback tokens
  static const String success = 'success';

  static const String aboutText = '''
Cardifly est une application mobile pensée pour vous accompagner au quotidien.

Elle est gratuite et sans publicité.

Développée par $authorName.
''';
}
