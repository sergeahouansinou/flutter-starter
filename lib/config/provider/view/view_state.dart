/// Page-level state used by all view models.
enum ViewState {
  idle,
  completed,
  success,
  busy,
  empty,
  error,
  serverError,
  errorValidate,
  errorNetwork,
  unAuthenticated,
  unAuthorized,
}

enum ErrorType { defaultError, networkError }

class ViewStateError {
  ViewStateError(this.errorType, {this.message, this.errorMessage}) {
    message ??= errorMessage;
  }

  ErrorType errorType;
  String? message;
  String? errorMessage;

  bool get isNetworkError => errorType == ErrorType.networkError;
}
