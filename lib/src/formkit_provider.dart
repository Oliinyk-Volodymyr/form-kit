import 'package:flutter/material.dart';

import 'formkit_controller.dart';
import 'formkit_types.dart';

/// Provider for passing FormKitController through widget tree
class FormKitProvider<K> extends InheritedWidget {
  const FormKitProvider({required this.controller, required super.child, super.key});

  final FormKitController<K> controller;

  /// Get controller from context
  static FormKitController<K> of<K>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<FormKitProvider<K>>();
    if (provider == null) {
      throw FlutterError(
        'FormKitProvider.of() called with a context that does not contain a FormKitProvider.\n'
        'No ancestor could be found starting from the context that was passed to FormKitProvider.of().\n'
        'The context used was:\n'
        '  $context',
      );
    }
    return provider.controller;
  }

  @override
  bool updateShouldNotify(FormKitProvider<K> oldWidget) => controller != oldWidget.controller;
}

/// Main FormKit widget
class FormKit<K> extends StatefulWidget {
  const FormKit({required this.config, required this.builder, super.key});

  final FormKitConfig<K> config;
  final Widget Function(BuildContext context, FormKitState<K> state) builder;

  @override
  State<FormKit<K>> createState() => _FormKitState<K>();
}

class _FormKitState<K> extends State<FormKit<K>> {
  late FormKitController<K> _controller;

  @override
  void initState() {
    super.initState();
    _controller = FormKitController<K>(config: widget.config);
  }

  @override
  void didUpdateWidget(FormKit<K> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.config.enableReinitialize && widget.config.initialValues != oldWidget.config.initialValues) {
      _controller.setValues(widget.config.initialValues);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormKitProvider<K>(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final state = FormKitState<K>(
            values: _controller.values,
            errors: _controller.errors,
            touched: _controller.touched,
            dirty: _controller.dirty,
            isDirty: _controller.isDirty,
            isValid: _controller.isValid,
            isSubmitting: _controller.isSubmitting,
            isValidating: _controller.isValidating,
          );

          return widget.builder(context, state);
        },
      ),
    );
  }
}
