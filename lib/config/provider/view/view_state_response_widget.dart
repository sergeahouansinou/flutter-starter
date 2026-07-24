import 'package:cardifly/ui/components/app_error_state.dart';
import 'package:cardifly/ui/components/app_loader.dart';
import 'package:flutter/material.dart';

import 'view_state.dart';

/// Full-height loader used inside response surfaces.
class ViewStateResponseBusyWidget extends StatelessWidget {
  const ViewStateResponseBusyWidget({super.key, this.label = 'Chargement…'});

  final String label;

  @override
  Widget build(BuildContext context) => AppLoaderCentered(label: label);
}

/// Response info message container.
class ViewStateResponseWidget extends StatelessWidget {
  const ViewStateResponseWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Text(
          message ?? '',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).textTheme.displaySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Response error surface.
class ViewStateResponseErrorWidget extends StatelessWidget {
  const ViewStateResponseErrorWidget({
    super.key,
    required this.error,
    this.message,
    this.onRetry,
  });

  final ViewStateError error;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final defaultMessage = error.errorType == ErrorType.networkError
        ? 'Vérifiez votre connexion internet puis réessayez.'
        : error.message;
    return AppErrorState(
      message: message ?? defaultMessage,
      onRetry: onRetry,
    );
  }
}
