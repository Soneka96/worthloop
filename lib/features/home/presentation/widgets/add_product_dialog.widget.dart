// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/features/product_form_field.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Dialog for entering a new tracked product's name.
class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) =>
      value == null || value.trim().isEmpty ? t.home.productNameRequired : null;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeScreenViewModel>(
      distinct: true,
      converter: (store) => sl<HomeScreenViewModel>(param1: store),
      onWillChange: (previous, current) {
        if (current.createdProductId != null &&
            current.createdProductId != previous?.createdProductId) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, viewmodel) {
        void submit() {
          if (viewmodel.isCreatingProduct ||
              !(_formKey.currentState?.validate() ?? false)) {
            return;
          }
          viewmodel.onCreateProduct(_nameController.text.trim());
        }

        final String? errorMessage = viewmodel.productCreationError;
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          key: const Key('add-product-dialog'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
          ),
          title: Text(t.home.addProductTitle),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductFormField(
                  key: const Key('add-product-name-field'),
                  controller: _nameController,
                  label: t.home.productNameLabel,
                  validator: _validateName,
                  onFieldSubmitted: (_) => submit(),
                  autofocus: true,
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: context.spacing.xs),
                  Text(
                    errorMessage,
                    key: const Key('add-product-error'),
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
              key: const Key('add-product-cancel-button'),
              onPressed: viewmodel.isCreatingProduct
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            FilledButton.icon(
              key: const Key('add-product-submit-button'),
              onPressed: viewmodel.isCreatingProduct ? null : submit,
              icon: viewmodel.isCreatingProduct
                  ? SizedBox.square(
                      dimension: IconSizes.md,
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.add),
              label: Text(
                viewmodel.isCreatingProduct
                    ? t.home.addProductSaving
                    : t.home.addProductButton,
              ),
            ),
          ],
        );
      },
    );
  }
}
