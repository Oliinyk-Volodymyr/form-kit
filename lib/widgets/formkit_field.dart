import 'package:flutter/material.dart';

import '../src/formkit_provider.dart';
import '../src/formkit_types.dart';

/// Widget for working with form fields
class FormKitField<K, T> extends StatefulWidget {
  const FormKitField({required this.fieldKey, required this.builder, super.key});

  final K fieldKey;
  final Widget Function(FormKitFieldState<T>) builder;

  @override
  State<FormKitField<K, T>> createState() => _FormKitFieldState<K, T>();
}

class _FormKitFieldState<K, T> extends State<FormKitField<K, T>> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = FormKitProvider.of<K>(context);

    final fieldState = FormKitFieldState<T>(
      value: controller.getValue(widget.fieldKey) as T,
      error: controller.getError(widget.fieldKey),
      touched: controller.getTouched(widget.fieldKey),
      hasError: controller.getError(widget.fieldKey) != null,
      onChange: (T value) => controller.setFieldValue(widget.fieldKey, value),
      onBlur: () => controller.setFieldTouched(widget.fieldKey, false),
    );

    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) => controller.setFieldTouched(widget.fieldKey, hasFocus),
      child: widget.builder(fieldState),
    );
  }
}

