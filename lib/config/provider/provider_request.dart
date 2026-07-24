import 'dart:convert';

import 'package:cardifly/anims/page_route_anim.dart';
import 'package:cardifly/config/provider/view/view_state.dart';
import 'package:cardifly/main.dart';
import 'package:cardifly/screens/home_screen.dart';
import 'package:cardifly/utils/types/feedback_type.dart';
import 'package:cardifly/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';

class ProviderRequest with ChangeNotifier {
  ProviderRequest({ViewState? viewState})
    : _viewState = viewState ?? ViewState.idle;

  bool _disposed = false;
  ViewState _viewState;
  ViewStateError? _viewStateError;

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  ViewStateError? get viewStateError => _viewStateError;
  String get errorMessage => _viewStateError?.message ?? '';

  bool get busy => _viewState == ViewState.busy;
  bool get success => _viewState == ViewState.success;
  bool get serverError => _viewState == ViewState.serverError;
  bool get errorValidate => _viewState == ViewState.errorValidate;
  bool get errorNetwork => _viewState == ViewState.errorNetwork;
  bool get unAuthorized => _viewState == ViewState.unAuthorized;
  bool get unAuthenticated => _viewState == ViewState.unAuthenticated;

  void setBusy() => viewState = ViewState.busy;
  void setSuccess() => viewState = ViewState.success;
  void setUnAuthorized() {
    viewState = ViewState.unAuthorized;
    onUnAuthorizedException();
  }

  void setUnAuthenticated() => viewState = ViewState.unAuthenticated;

  void onUnAuthorizedException() {}

  void setError(Object e, StackTrace? stackTrace, {String? message}) {
    var finalMessage = message;
    if (e is DioException) {
      stackTrace = null;
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        String? errorMessage;
        try {
          final decoded = jsonDecode(e.response.toString())
              as Map<String, dynamic>?;
          errorMessage = decoded?['message'] as String?;
        } catch (_) {
          errorMessage = null;
        }

        switch (statusCode) {
          case 403:
            finalMessage = 'Accès refusé';
            setUnAuthorized();
            Util.displayNotification(
              message: errorMessage ?? finalMessage,
              type: FeedbackType.error,
            );
          case 401:
            finalMessage = 'Session expirée';
            setUnAuthenticated();
            Util.displayNotification(
              message: 'Votre session a expiré, veuillez vous reconnecter',
              type: FeedbackType.error,
            );
            NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
              KyNavigate.slideIn(const HomeScreen()),
              (route) => false,
            );
          case 422:
            finalMessage = 'Erreur de validation';
            viewState = ViewState.errorValidate;
            Util.displayNotification(
              message: errorMessage ??
                  "Une erreur s'est produite lors de la validation des données",
              type: FeedbackType.error,
            );
          case 404:
            finalMessage = 'Introuvable';
            viewState = ViewState.errorValidate;
            Util.displayNotification(
              message: errorMessage ?? 'La ressource demandée est introuvable',
              type: FeedbackType.error,
            );
          case 500:
            finalMessage = 'Erreur serveur';
            viewState = ViewState.serverError;
            Util.displayNotification(
              message: errorMessage ??
                  "Une erreur s'est produite lors du traitement de votre demande",
              type: FeedbackType.error,
            );
          default:
            finalMessage = 'Erreur';
            viewState = ViewState.serverError;
            Util.displayNotification(
              message: errorMessage ?? e.error.toString(),
              type: FeedbackType.error,
            );
        }
      } else {
        viewState = ViewState.errorNetwork;
        Util.displayNotification(
          message: 'Erreur de connexion',
          type: FeedbackType.warning,
        );
        return;
      }
    }

    _viewStateError = ViewStateError(
      ErrorType.defaultError,
      message: finalMessage,
      errorMessage: e.toString(),
    );
    _printErrorStack(e, stackTrace);
  }

  void showErrorMessage(String? message) {
    final resolved = message ??
        (_viewStateError?.isNetworkError == true
            ? 'Erreur de serveur'
            : _viewStateError?.message);
    if (resolved == null) return;
    Future.microtask(() => toast(resolved));
  }

  @override
  String toString() =>
      'ProviderRequest{state: $_viewState, error: $_viewStateError}';

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

void _printErrorStack(Object e, StackTrace? s) {
  if (!kDebugMode) return;
  debugPrint('ERROR: $e');
  if (s != null) debugPrint('STACK: $s');
}
