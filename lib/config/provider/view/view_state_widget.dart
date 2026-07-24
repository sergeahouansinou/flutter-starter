import 'package:cardifly/ui/components/app_empty_state.dart';
import 'package:cardifly/ui/components/app_error_state.dart';
import 'package:cardifly/ui/components/app_loader.dart';
import 'package:flutter/material.dart';

import 'view_state.dart';

/// Loading state.
class ViewStateBusyWidget extends StatelessWidget {
  const ViewStateBusyWidget({super.key, this.label = 'Chargement…'});

  final String label;

  @override
  Widget build(BuildContext context) => AppLoaderCentered(label: label);
}

/// Reusable inline (row-style) message + retry button.
class ViewLinearStateWidget extends StatelessWidget {
  const ViewLinearStateWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(onPressed: onPressed, child: const Text('Réessayer')),
      ],
    );
  }
}

/// Reusable inline error state.
class ViewLinearStateErrorWidget extends ViewLinearStateWidget {
  const ViewLinearStateErrorWidget({
    super.key,
    required super.title,
    required super.onPressed,
  });
}

/// Generic full state widget for empty / error surfaces.
class ViewStateWidget extends StatelessWidget {
  const ViewStateWidget({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.buttonTextData,
    required this.onPressed,
  });

  final String? title;
  final String? message;
  final IconData? icon;
  final String? buttonTextData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title ?? 'Aucune donnée',
      message: message,
      icon: icon ?? Icons.inbox_outlined,
      actionLabel: buttonTextData ?? 'Réessayer',
      onAction: onPressed,
    );
  }
}

/// Error surface tied to a [ViewStateError].
class ViewStateErrorWidget extends StatelessWidget {
  const ViewStateErrorWidget({
    super.key,
    required this.error,
    this.title,
    this.message,
    this.buttonTextData,
    required this.onPressed,
  });

  final ViewStateError error;
  final String? title;
  final String? message;
  final String? buttonTextData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final defaultTitle = error.errorType == ErrorType.networkError
        ? 'Erreur de connexion'
        : 'Une erreur est survenue';
    final defaultMessage = error.errorType == ErrorType.networkError
        ? 'Vérifiez votre connexion internet puis réessayez.'
        : error.message;

    return AppErrorState(
      title: title ?? defaultTitle,
      message: message ?? defaultMessage,
      onRetry: onPressed,
      retryLabel: buttonTextData ?? 'Réessayer',
    );
  }
}

/// Empty widget shown when a list has no data.
class ViewEmptyWidget extends StatelessWidget {
  const ViewEmptyWidget({super.key, this.message, this.icon});

  final String? message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'Aucune donnée',
      message: message,
      icon: icon ?? Icons.inbox_outlined,
    );
  }
}
