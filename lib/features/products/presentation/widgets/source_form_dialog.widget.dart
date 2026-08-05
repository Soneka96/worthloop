// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/features/product_form_field.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Dialog for adding a source, or editing [source]'s URL when one is given.
class SourceFormDialog extends StatefulWidget {
  /// Identifier of the product this source belongs to.
  final String productId;

  /// The source being edited, or `null` when adding a new one.
  final ProductSource? source;

  const SourceFormDialog({required this.productId, this.source, super.key});

  @override
  State<SourceFormDialog> createState() => _SourceFormDialogState();
}

class _SourceFormDialogState extends State<SourceFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;

  bool get _isEdit => widget.source != null;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.source?.url ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) => value == null || value.trim().isEmpty
      ? t.productDetails.sourceUrlRequired
      : null;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDetailsViewModel>(
      distinct: true,
      converter: (store) =>
          sl<ProductDetailsViewModel>(param1: store, param2: widget.productId),
      onWillChange: (previous, current) {
        final bool succeeded = _isEdit
            ? previous?.editingSourceId == widget.source!.id &&
                  current.editingSourceId == null &&
                  current.editSourceError == null
            : previous?.isAddingSource == true &&
                  !current.isAddingSource &&
                  current.addSourceError == null;
        if (succeeded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, viewmodel) {
        final bool isSubmitting = _isEdit
            ? viewmodel.editingSourceId == widget.source!.id
            : viewmodel.isAddingSource;
        final String? errorMessage = _isEdit
            ? viewmodel.editSourceError
            : viewmodel.addSourceError;

        void submit() {
          if (isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
            return;
          }
          final String url = _urlController.text.trim();
          if (_isEdit) {
            viewmodel.onEditSource(widget.source!.id, url);
          } else {
            viewmodel.onAddSource(url);
          }
        }

        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          key: const Key('source-form-dialog'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
          ),
          title: Text(
            _isEdit
                ? t.productDetails.editSourceTitle
                : t.productDetails.addSourceTitle,
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductFormField(
                  key: const Key('source-form-url-field'),
                  controller: _urlController,
                  label: t.productDetails.sourceUrlLabel,
                  hint: t.productDetails.sourceUrlHint,
                  keyboardType: TextInputType.url,
                  validator: _validateUrl,
                  onFieldSubmitted: (_) => submit(),
                  autofocus: true,
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: context.spacing.xs),
                  Text(
                    errorMessage,
                    key: const Key('source-form-error'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              key: const Key('source-form-cancel-button'),
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            FilledButton.icon(
              key: const Key('source-form-submit-button'),
              onPressed: isSubmitting ? null : submit,
              icon: isSubmitting
                  ? SizedBox.square(
                      dimension: IconSizes.md,
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.add),
              label: Text(
                isSubmitting
                    ? t.productDetails.savingSource
                    : (_isEdit
                          ? t.productDetails.saveSourceButton
                          : t.productDetails.addSourceButton),
              ),
            ),
          ],
        );
      },
    );
  }
}
