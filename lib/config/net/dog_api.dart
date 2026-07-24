import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Standalone Dio instance for the public Dog API v2 (https://dogapi.dog).
///
/// Kept separate from the app's [Http] client because:
///   * it hits an external base URL,
///   * it must not carry the `Authorization` / `App-Version` headers,
///   * it returns raw JSON:API envelopes (`{data, meta, links}`) that our
///     internal [ApiInterceptor] would eagerly unwrap.
class DogApiHttp {
  const DogApiHttp._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'https://dogapi.dog/api/v2/',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
      responseType: ResponseType.json,
    ),
  )..interceptors.add(_LogInterceptor());
}

/// App-scoped singleton alias.
final Dio dogHttp = DogApiHttp.instance;

class _LogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '→ Dog API ${options.method} ${options.baseUrl}${options.path} '
        'q=${options.queryParameters}',
      );
    }
    super.onRequest(options, handler);
  }
}
