import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'formkit_types.dart';

/// Controller for managing form state
class FormKitController<K> extends ChangeNotifier {
  FormKitController({required this.config}) : _values = Map.from(config.initialValues);

  final FormKitConfig<K> config;

  Map<K, dynamic> _values;
  Map<K, String> _errors = {};
  Map<K, bool> _touched = {};
  Map<K, bool> _dirty = {};
  bool _isSubmitting = false;
  bool _isValidating = false;

  /// Current form values
  Map<K, dynamic> get values => UnmodifiableMapView(_values);

  /// Validation errors
  Map<K, String> get errors => Map.unmodifiable(_errors);

  /// Touched fields
  Map<K, bool> get touched => Map.unmodifiable(_touched);

  /// Dirty fields (changed from initial values)
  Map<K, bool> get dirty => Map.unmodifiable(_dirty);

  /// Whether the form is valid
  bool get isValid => _errors.isEmpty;

  /// Whether the form is being submitted
  bool get isSubmitting => _isSubmitting;

  /// Whether the form is being validated
  bool get isValidating => _isValidating;

  /// Get field value by name
  dynamic getValue(K fieldKey) => _values[fieldKey];

  /// Set field value
  void setFieldValue(K fieldKey, dynamic value) {
    _values[fieldKey] = value;

    // Update dirty state by comparing with initial value
    final initialValue = config.initialValues[fieldKey];
    _dirty[fieldKey] = value != initialValue;

    if (config.validateOnChange) {
      _validateField(fieldKey);
    }

    notifyListeners();
  }

  /// Get field error
  String? getError(K fieldKey) {
    return _errors[fieldKey];
  }

  /// Set field error
  void setFieldError(K fieldKey, String? error) {
    if (error != null) {
      _errors[fieldKey] = error;
    } else {
      _errors.remove(fieldKey);
    }
    notifyListeners();
  }

  /// Get field touched state
  bool getTouched(K fieldKey) {
    return _touched[fieldKey] ?? false;
  }

  /// Set field touched state
  void setFieldTouched(K fieldKey, bool touched) {
    _touched[fieldKey] = touched;

    if (config.validateOnBlur && touched) {
      _validateField(fieldKey);
    }

    notifyListeners();
  }

  /// Get field dirty state
  bool getDirty(K fieldKey) {
    return _dirty[fieldKey] ?? false;
  }

  /// Check if form has any dirty fields
  bool get isDirty => _dirty.values.any((dirty) => dirty);

  /// Check if specific field is dirty
  bool isFieldDirty(K fieldKey) {
    return _dirty[fieldKey] ?? false;
  }

  /// Get only dirty field values
  Map<K, dynamic> get dirtyValues {
    final dirtyValues = <K, dynamic>{};
    for (final entry in _values.entries) {
      if (_dirty[entry.key] ?? false) {
        dirtyValues[entry.key] = entry.value;
      }
    }
    return dirtyValues;
  }

  /// Get only dirty field keys
  List<K> get dirtyFields {
    return _dirty.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
  }

  /// Reset specific field to initial value
  void resetField(K fieldKey) {
    final initialValue = config.initialValues[fieldKey];
    _values[fieldKey] = initialValue;
    _dirty[fieldKey] = false;
    _errors.remove(fieldKey);
    _touched[fieldKey] = false;
    notifyListeners();
  }

  /// Validate specific field
  Future<void> _validateField(K fieldKey) async {
    if (config.validationSchema == null) return;

    _isValidating = true;
    notifyListeners();

    try {
      final validators = config.validationSchema!(_values);
      final validator = validators[fieldKey];

      if (validator != null) {
        final fieldValue = getValue(fieldKey);
        final error = await validator(fieldValue);
        setFieldError(fieldKey, error);
      }
    } finally {
      _isValidating = false;
      notifyListeners();
    }
  }

  /// Validate entire form
  Future<void> validateForm() async {
    if (config.validationSchema == null) return;

    _isValidating = true;
    notifyListeners();

    try {
      final validators = config.validationSchema!(_values);
      final newErrors = <K, String>{};

      for (final entry in validators.entries) {
        final fieldKey = entry.key;
        final validator = entry.value;
        final fieldValue = getValue(fieldKey);
        final error = await validator(fieldValue);

        if (error != null) {
          newErrors[fieldKey] = error;
        }
      }

      _errors = newErrors;
    } finally {
      _isValidating = false;
      notifyListeners();
    }
  }

  /// Submit form
  Future<void> submit() async {
    if (config.onSubmit == null) return;

    await validateForm();

    if (!isValid) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      await config.onSubmit!(_values);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Reset form to initial values
  void reset() {
    _values = Map.from(config.initialValues);
    _errors.clear();
    _touched.clear();
    _dirty.clear();
    _isSubmitting = false;
    _isValidating = false;
    notifyListeners();
  }

  /// Set form values (useful for editing)
  void setValues(Map<K, dynamic> values) {
    _values = Map.from(values);
    _errors.clear();
    _touched.clear();

    // Update dirty state for all fields
    _dirty.clear();
    for (final entry in values.entries) {
      final fieldKey = entry.key;
      final value = entry.value;
      final initialValue = config.initialValues[fieldKey];
      _dirty[fieldKey] = value != initialValue;
    }

    notifyListeners();
  }
}
