import 'dart:io';

import 'package:cardifly/core/viewmodels/local_view_model.dart';
import 'package:cardifly/main.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'base_api.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = Constants.baseUrl;
    interceptors.add(ApiInterceptor());
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx != null) {
      final locale = Provider.of<LocaleModel>(ctx, listen: false);
      options.headers['language'] = locale.localeString;
    }

    if (!kIsWeb) {
      options.headers['platform'] = Platform.operatingSystem;
    }
    options.headers['app_version'] = Constants.appVersion;

    if (kDebugMode) {
      debugPrint(
        '→ ${options.method} ${options.baseUrl}${options.path} '
        'q=${options.queryParameters} data=${options.data}',
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final respData = ResponseData.fromJson(
      response.data as Map<String, dynamic>,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      response.data = respData.data;
      return handler.resolve(response);
    }
    if (response.statusCode == 400) {
      throw const UnAuthorizedException();
    }
    throw NotSuccessException.fromRespData(respData);
  }
}

class ResponseData extends BaseResponseData {
  ResponseData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    error = json['error_message'] as String?;
  }

  @override
  bool get success => code == 200;
}
