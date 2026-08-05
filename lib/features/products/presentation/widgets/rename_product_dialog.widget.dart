// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/features/product_form_field.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Dialog for renaming an existing tracked product.
class RenameProductDialog extends StatefulWidget {
  /// Identifier of the product being renamed.
  final String productId;

  /// The product's current name, used to prefill the field.
  final String currentName;

  const RenameProductDialog({
    required this.productId,
    required this.currentName,
    super.key,
  });

  @override
  State<RenameProductDialog> createState() => _RenameProductDialogState();
}

class _RenameProductDialogState extends State<RenameProductDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) => value == null || value.trim().isEmpty
      ? t.productDetails.renameProductRequired
      : null;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDetailsViewModel>(
      distinct: true,
      converter: (store) =>
          sl<ProductDetailsViewModel>(param1: store, param2: widget.productId),
      onWillChange: (previous, current) {
        final bool succeeded =
            previous?.isRenamingProduct == true &&
            !current.isRenamingProduct &&
            current.renameProductError == null;
        if (succeeded) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, viewmodel) {
        final bool isSubmitting = viewmodel.isRenamingProduct;
        final String? errorMessage = viewmodel.renameProductError;

        void submit() {
          if (isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
            return;
          }
          viewmodel.onRenameProduct(_nameController.text.trim());
        }

        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          key: const Key('rename-product-dialog'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
          ),
          title: Text(t.productDetails.renameProductTitle),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductFormField(
                  key: const Key('rename-product-name-field'),
                  controller: _nameController,
                  label: t.productDetails.productNameLabel,
                  validator: _validateName,
                  onFieldSubmitted: (_) => submit(),
                  autofocus: true,
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: context.spacing.xs),
                  Text(
                    errorMessage,
                    key: const Key('rename-product-error'),
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
              key: const Key('rename-product-cancel-button'),
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            FilledButton.icon(
              key: const Key('rename-product-submit-button'),
              onPressed: isSubmitting ? null : submit,
              icon: isSubmitting
                  ? SizedBox.square(
                      dimension: IconSizes.md,
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(
                isSubmitting
                    ? t.productDetails.renameProductSaving
                    : t.productDetails.renameProductButton,
              ),
            ),
          ],
        );
      },
    );
  }
}
