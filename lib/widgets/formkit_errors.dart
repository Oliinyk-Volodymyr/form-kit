import 'package:flutter/material.dart';

import '../src/formkit_provider.dart';

/// Widget for displaying form errors
class FormKitErrors extends StatelessWidget {
  const FormKitErrors({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final controller = FormKitProvider.of<String>(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.errors.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.errors.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(entry.value, style: style ?? const TextStyle(color: Colors.red)),
            );
          }).toList(),
        );
      },
    );
  }
}

