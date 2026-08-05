// Flutter imports:
import 'package:flutter/material.dart';

/// Reusable labeled input for the add-product form.
class ProductFormField extends StatelessWidget {
  /// Controller for the field's text.
  final TextEditingController controller;

  /// Field label.
  final String label;

  /// Optional hint shown before text is entered.
  final String? hint;

  /// Keyboard configuration for the field.
  final TextInputType keyboardType;

  /// Validation callback for the field.
  final String? Function(String?) validator;

  /// Called when the user submits the field from the keyboard.
  final ValueChanged<String>? onFieldSubmitted;

  const ProductFormField({
    required this.controller,
    required this.label,
    required this.validator,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: label, hintText: hint),
    textInputAction: onFieldSubmitted == null
        ? TextInputAction.next
        : TextInputAction.done,
    onFieldSubmitted: onFieldSubmitted,
    validator: validator,
  );
}
