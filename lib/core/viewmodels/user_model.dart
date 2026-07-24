import 'dart:convert';

import 'package:cardifly/config/provider/provider_request.dart';
import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/core/models/user.dart';
import 'package:cardifly/core/services/user_service.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:cardifly/utils/enums/connexion_source.dart';
import 'package:cardifly/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserModel extends ProviderRequest {
  User? userRes;
  User? userProfile;
  List<User>? followers;

  Future<void> register(User user) async {
    setBusy();
    try {
      await UserService.register(user);
      setSuccess();
    } on DioException catch (e, s) {
      _logResponse(e);
      setError(e, s);
    }
  }

  Future<void> update(User user) async {
    setBusy();
    try {
      final updated = await UserService.update(user);
      updated.token = user.token;
      userRes = updated;
      await _persistUser(updated);
      setSuccess();
    } on DioException catch (e, s) {
      _logResponse(e);
      setError(e, s);
    }
  }

  void setUser(User user) {
    userRes = user;
    setSuccess();
  }

  Future<void> signIn(User user, ConnexionSource source) async {
    setBusy();
    try {
      final res = await UserService.signIn(user, source);
      userRes = res;
      await _persistUser(res);
      await _persistToken(res.token);
      await StorageManager.sharedPreferences?.setBool(
        Constants.kIsLogged,
        true,
      );
      setSuccess();
    } on DioException catch (e, s) {
      _logResponse(e);
      setError(e, s);
    }
  }

  Future<void> activeAccount(User user) async {
    setBusy();
    try {
      final res = await UserService.verifyEmail(user);
      userRes = res;
      final prefs = StorageManager.sharedPreferences;
      await prefs?.setBool(Constants.kIsAccountActivated, true);
      await _persistUser(res);
      await _persistToken(res.token);
      await prefs?.setBool(Constants.kIsLogged, true);
      setSuccess();
    } on DioException catch (e, s) {
      setError(e, s);
    }
  }

  Future<void> getUser() async {
    setBusy();
    try {
      final res = await UserService.getUser();
      userRes = res;
      await _persistUser(res);
      setSuccess();
    } on DioException catch (e, s) {
      setError(e, s);
    }
  }

  Future<void> requestVerificationCode(String email) async {
    setBusy();
    try {
      await UserService.requestVerificationCode(email);
      setSuccess();
    } on DioException catch (e, s) {
      setError(e, s);
    }
  }

  Future<void> passwordForgotten(String email) async {
    setBusy();
    try {
      await UserService.passwordForgotten(email);
      setSuccess();
    } on DioException catch (e, s) {
      _logResponse(e);
      setError(e, s);
    }
  }

  Future<void> resetPassword(User user) async {
    setBusy();
    try {
      await UserService.resetPassword(user);
      setSuccess();
    } on DioException catch (e, s) {
      _logResponse(e);
      setError(e, s);
    }
  }

  Future<void> logout() async {
    setBusy();
    try {
      await UserService.logout();
      final prefs = StorageManager.sharedPreferences;
      await prefs?.remove(Constants.kUserInfo);
      await prefs?.remove(Constants.kIsLogged);
      await prefs?.remove(Constants.kIsAccountActivated);
      await prefs?.remove(Constants.kToken);
      await prefs?.remove(Constants.kArtistsFollowedIds);
      await prefs?.remove(Constants.kArtistInfo);
      await prefs?.remove(Constants.kIsArtist);
      setSuccess();
    } on DioException catch (e, s) {
      setError(e, s);
    }
  }

  User? getLoggedUser() {
    setBusy();
    try {
      userRes = Util.getUserInfo();
      setSuccess();
      return userRes;
    } catch (e) {
      if (kDebugMode) debugPrint('getLoggedUser error --> $e');
      return null;
    }
  }

  bool isLogged() =>
      StorageManager.sharedPreferences?.getBool(Constants.kIsLogged) ?? false;

  bool isAccountActivated() =>
      StorageManager.sharedPreferences
          ?.getBool(Constants.kIsAccountActivated) ??
      false;

  Future<void> delete() async {
    setBusy();
    try {
      await UserService.delete(userRes?.id);
      final prefs = StorageManager.sharedPreferences;
      await prefs?.remove(Constants.kUserInfo);
      await prefs?.remove(Constants.kIsLogged);
      await prefs?.remove(Constants.kToken);
      await prefs?.remove(Constants.kFcmToken);
      setSuccess();
    } catch (e, s) {
      setError(e, s);
    }
  }

  Future<void> _persistUser(User user) async {
    await StorageManager.sharedPreferences?.setString(
      Constants.kUserInfo,
      jsonEncode(user.toJson()),
    );
  }

  Future<void> _persistToken(String? token) async {
    await StorageManager.sharedPreferences?.setString(
      Constants.kToken,
      token ?? '',
    );
  }

  void _logResponse(DioException e) {
    if (kDebugMode) debugPrint('${e.response}');
  }
}
