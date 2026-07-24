import 'package:cardifly/config/net/base_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';

import 'view_state.dart';

class ViewStateModel with ChangeNotifier {
  ViewStateModel({ViewState? viewState}) : _viewState = viewState;

  bool _disposed = false;
  ViewState? _viewState;
  ViewStateError? _viewStateError;

  ViewState? get viewState => _viewState;

  set viewState(ViewState? viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  ViewStateError? get viewStateError => _viewStateError;
  String? get errorMessage => _viewStateError?.message;

  bool get busy => _viewState == ViewState.busy;
  bool get idle => _viewState == ViewState.idle;
  bool get empty => _viewState == ViewState.empty;
  bool get error => _viewState == ViewState.error;
  bool get unAuthorized => _viewState == ViewState.unAuthorized;

  void setIdle() => viewState = ViewState.idle;
  void setBusy() => viewState = ViewState.busy;
  void setEmpty() => viewState = ViewState.empty;
  void setUnAuthorized() {
    viewState = ViewState.unAuthorized;
    onUnAuthorizedException();
  }

  void onUnAuthorizedException() {}

  void setError(Object e, StackTrace? stackTrace, {required String message}) {
    var errorType = ErrorType.defaultError;
    var resolved = message;
    Object cause = e;

    if (cause is DioException) {
      final inner = cause.error;
      if (inner is UnAuthorizedException) {
        setUnAuthorized();
        return;
      }
      if (inner is NotSuccessException) {
        resolved = inner.error ?? message;
      } else {
        errorType = ErrorType.networkError;
      }
      stackTrace = null;
    }

    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: resolved,
      errorMessage: cause.toString(),
    );
    _log(cause, stackTrace);
  }

  void showErrorMessage(String? message) {
    final resolved = message ??
        (_viewStateError?.isNetworkError == true
            ? 'Erreur réseau'
            : _viewStateError?.message);
    if (resolved == null) return;
    Future.microtask(() => toast(resolved));
  }

  @override
  String toString() =>
      'ViewStateModel{state: $_viewState, error: $_viewStateError}';

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

void _log(Object e, StackTrace? s) {
  if (!kDebugMode) return;
  debugPrint('ERROR: $e');
  if (s != null) debugPrint('STACK: $s');
}
