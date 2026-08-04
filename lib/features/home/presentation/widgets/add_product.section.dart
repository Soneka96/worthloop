// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/product_form_field.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Expandable form for adding a product website link.
class AddProductSection extends StatefulWidget {
  /// Whether the product is currently being saved.
  final bool isSubmitting;

  /// The latest creation error, or `null`.
  final String? errorMessage;

  /// Identifier of the latest created product, or `null`.
  final String? createdProductId;

  /// Called with the entered product name and website URL.
  final void Function(String name, String url) onSubmit;

  const AddProductSection({
    required this.isSubmitting,
    required this.errorMessage,
    required this.createdProductId,
    required this.onSubmit,
    super.key,
  });

  @override
  State<AddProductSection> createState() => _AddProductSectionState();
}

class _AddProductSectionState extends State<AddProductSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant AddProductSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.createdProductId != null &&
        widget.createdProductId != oldWidget.createdProductId) {
      _nameController.clear();
      _urlController.clear();
      _formKey.currentState?.reset();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    widget.onSubmit(_nameController.text.trim(), _urlController.text.trim());
  }

  String? _validateName(String? value) =>
      value == null || value.trim().isEmpty ? t.home.productNameRequired : null;

  String? _validateUrl(String? value) {
    final Uri? uri = Uri.tryParse(value?.trim() ?? '');
    return uri == null || uri.scheme != 'https' || uri.host.isEmpty
        ? t.home.productUrlInvalid
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final String? errorMessage = widget.errorMessage;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: ExpansionTile(
            key: const Key('add-product-section'),
            leading: const Icon(Icons.add_shopping_cart),
            title: Text(t.home.addProductTitle),
            subtitle: Text(t.home.addProductDescription),
            childrenPadding: EdgeInsets.fromLTRB(
              context.spacing.md,
              0,
              context.spacing.md,
              context.spacing.md,
            ),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductFormField(
                      key: const Key('add-product-name-field'),
                      controller: _nameController,
                      label: t.home.productNameLabel,
                      validator: _validateName,
                    ),
                    SizedBox(height: context.spacing.sm),
                    ProductFormField(
                      key: const Key('add-product-url-field'),
                      controller: _urlController,
                      label: t.home.productUrlLabel,
                      hint: t.home.productUrlHint,
                      keyboardType: TextInputType.url,
                      onFieldSubmitted: (_) => _submit(),
                      validator: _validateUrl,
                    ),
                    SizedBox(height: context.spacing.md),
                    FilledButton.icon(
                      key: const Key('add-product-submit-button'),
                      onPressed: widget.isSubmitting ? null : _submit,
                      icon: widget.isSubmitting
                          ? SizedBox.square(
                              dimension: IconSizes.md,
                              child: CircularProgressIndicator(
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.add),
                      label: Text(
                        widget.isSubmitting
                            ? t.home.addProductSaving
                            : t.home.addProductButton,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    );
  }
}
