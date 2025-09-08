/// Core types and interfaces for FormKit
library formkit_types;

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Base type for form values
typedef FormKitValues = Map<String, dynamic>;

/// Validation function for a field
typedef FormKitValidator<T> = FutureOr<String?> Function(T value);

/// Validation schema for the entire form
typedef FormKitValidationSchema<K, T> = Map<K, FormKitValidator<dynamic>> Function(T values);

/// Form submission handler
typedef FormKitSubmitHandler<T> = Future<void> Function(T values);

/// Field state containing value, error, and interaction state
class FormKitFieldState<T> {
  const FormKitFieldState({
    required this.value,
    required this.onChange,
    required this.onBlur,
    this.error,
    this.touched = false,
    this.hasError = false,
  });

  /// Current field value
  final T value;

  /// Field validation error message
  final String? error;

  /// Whether the field has been touched (focused and blurred)
  final bool touched;

  /// Whether the field has a validation error
  final bool hasError;

  /// Callback to update field value
  final ValueChanged<T> onChange;

  /// Callback when field loses focus
  final VoidCallback onBlur;
}

/// Form state containing all form data and state
class FormKitState<K> {
  const FormKitState({
    required this.values,
    required this.errors,
    required this.touched,
    required this.dirty,
    required this.isDirty,
    required this.isValid,
    required this.isSubmitting,
    required this.isValidating,
  });

  /// Current form values
  final Map<K, dynamic> values;

  /// Validation errors for all fields
  final Map<K, String> errors;

  /// Touched state for all fields
  final Map<K, bool> touched;

  /// Dirty state for all fields (changed from initial values)
  final Map<K, bool> dirty;

  /// Whether the form is dirty (has changed from initial values)
  final bool isDirty;

  /// Whether the form is valid (no errors)
  final bool isValid;

  /// Whether the form is currently being submitted
  final bool isSubmitting;

  /// Whether the form is currently being validated
  final bool isValidating;
}

/// FormKit configuration
class FormKitConfig<K> {
  const FormKitConfig({
    required this.initialValues,
    this.validationSchema,
    this.onSubmit,
    this.validateOnChange = true,
    this.validateOnBlur = true,
    this.enableReinitialize = false,
  });

  /// Initial form values
  final Map<K, dynamic> initialValues;

  /// Validation schema for the form
  final FormKitValidationSchema<K, dynamic>? validationSchema;

  /// Form submission handler
  final FormKitSubmitHandler<Map<K, dynamic>>? onSubmit;

  /// Whether to validate on field change
  final bool validateOnChange;

  /// Whether to validate on field blur
  final bool validateOnBlur;

  /// Whether to reinitialize form when initialValues change
  final bool enableReinitialize;
}
