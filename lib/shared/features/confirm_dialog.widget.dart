// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';

/// A confirm/cancel dialog for a single destructive action.
class ConfirmDialog extends StatelessWidget {
  /// What is being confirmed, shown as the dialog title.
  final String title;

  /// Explains the consequence of confirming.
  final String message;

  /// Label for the destructive confirm action.
  final String confirmLabel;

  const ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    super.key,
  });

  /// Shows a [ConfirmDialog] and returns `true` only if the user confirmed.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          key: const Key('confirm-dialog-cancel-button'),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t.common.cancel),
        ),
        FilledButton(
          key: const Key('confirm-dialog-confirm-button'),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
