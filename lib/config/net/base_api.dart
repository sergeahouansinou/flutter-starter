import 'dart:io';

import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:cardifly/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

abstract class BaseHttp extends DioForNative {
  BaseHttp() {
    interceptors.add(HeaderInterceptor());
    init();
  }

  void init();
}

class HeaderInterceptor extends InterceptorsWrapper {
  static const _defaultTimeout = Duration(seconds: 30);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final lang = _platformLanguage();
    final token = Util.getToken();

    options
      ..connectTimeout = _defaultTimeout
      ..receiveTimeout = _defaultTimeout
      ..sendTimeout = _defaultTimeout
      ..contentType = 'application/x-www-form-urlencoded; charset=UTF-8'
      ..headers['X-Requested-With'] = 'XMLHttpRequest'
      ..headers['Accept'] = 'application/json'
      ..headers['language'] = Util.getUserInfo()?.language ?? lang
      ..headers['platform'] = _platformName()
      ..headers['App-Version'] = Constants.appVersion;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final prefs = StorageManager.sharedPreferences;
      prefs?.remove(Constants.kUserInfo);
      prefs?.remove(Constants.kToken);
      prefs?.remove(Constants.kIsLogged);
    }
    super.onError(err, handler);
  }

  String _platformLanguage() {
    if (kIsWeb) return 'en';
    return Platform.localeName.split('_').first;
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    return Platform.operatingSystem;
  }
}

abstract class BaseResponseData {
  BaseResponseData({this.code, this.error, this.data});

  int? code = 0;
  String? error;
  Object? data;

  bool get success;

  @override
  String toString() =>
      'BaseRespData{code: $code, message: $error, data: $data}';
}

class NotSuccessException implements Exception {
  NotSuccessException.fromRespData(BaseResponseData respData)
      : error = respData.error;

  final String? error;

  @override
  String toString() => 'NotSuccessException{$error}';
}

class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}
