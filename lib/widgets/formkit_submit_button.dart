import 'package:flutter/material.dart';

import '../src/formkit_provider.dart';

/// Widget for form submission button
class FormKitSubmitButton extends StatelessWidget {
  const FormKitSubmitButton({required this.child, this.onPressed, super.key});

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = FormKitProvider.of<String>(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ElevatedButton(
          onPressed: controller.isSubmitting || !controller.isValid
              ? null
              : () {
                  if (onPressed != null) {
                    onPressed!();
                  } else {
                    controller.submit();
                  }
                },
          child: controller.isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : this.child,
        );
      },
    );
  }
}

