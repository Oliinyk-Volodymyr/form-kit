# FormKit

A powerful form management library for Flutter inspired by React Formik.

## Features

- 🎯 **Centralized State Management** - All form data in one place
- ✅ **Automatic Validation** - Sync and async validation support
- 🚨 **Error Handling** - Automatic error display
- 👆 **Touch/Dirty States** - Track field interactions
- 🔒 **Type Safety** - Full Dart type support
- 🚀 **Performance** - Optimized rebuilds

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  formkit: ^1.0.0
```

## Quick Start

```dart
import 'package:formkit/formkit.dart';

FormKit<Map<String, dynamic>>(
  config: FormKitConfig<Map<String, dynamic>>(
    initialValues: const {'name': '', 'email': ''},
    validationSchema: (values) => {
      'name': (value) => (value as String?)?.isEmpty == true ? 'Required' : null,
      'email': (value) => !EmailValidator.validate(value as String) ? 'Invalid' : null,
    },
    onSubmit: (values) async {
      print('Form submitted: $values');
    },
  ),
  builder: (context, state) => Column(
    children: [
      FormKitField<String>(
        name: 'name',
        builder: (field) => TextField(
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: field.touched ? field.error : null,
          ),
          onChanged: field.onChange,
        ),
      ),
      FormKitSubmitButton(
        child: Text(state.isSubmitting ? 'Submitting...' : 'Submit'),
      ),
    ],
  ),
)
```

## API Reference

### FormKit<T>

Main widget that wraps the form and provides context for all child components.

```dart
FormKit<Map<String, dynamic>>(
  config: FormKitConfig<Map<String, dynamic>>(
    initialValues: {...},
    validationSchema: (values) => {...},
    onSubmit: (values) async {...},
  ),
  builder: (context, state) => ...,
)
```

### FormKitField<T>

Widget for working with individual form fields.

```dart
FormKitField<String>(
  name: 'fieldName',
  builder: (fieldState) => YourWidget(fieldState: fieldState),
)
```

### FormKitSubmitButton

Form submission button with automatic state management.

```dart
FormKitSubmitButton(
  child: ElevatedButton(
    onPressed: null, // Managed automatically
    child: Text('Submit'),
  ),
)
```

### FormKitErrors

Widget for displaying form errors.

```dart
FormKitErrors(
  style: TextStyle(color: Colors.red),
)
```

## Form State

FormKitState provides access to the current form state:

```dart
FormKitState<T> {
  final T values;                    // Current form values
  final Map<String, String> errors;    // Validation errors
  final Map<String, bool> touched;   // Touched fields
  final bool isValid;                // Whether form is valid
  final bool isSubmitting;           // Whether form is being submitted
  final bool isValidating;           // Whether form is being validated
}
```

## Validation

### Synchronous Validation

```dart
validationSchema: (values) => {
  'email': (dynamic value) {
    final stringValue = value as String?;
    if (stringValue == null || stringValue.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(stringValue)) {
      return 'Invalid email format';
    }
    return null;
  },
}
```

### Asynchronous Validation

```dart
validationSchema: (values) => {
  'username': (dynamic value) async {
    final stringValue = value as String?;
    if (stringValue == null || stringValue.isEmpty) {
      return 'Username is required';
    }
    
    // Server check
    final isAvailable = await checkUsernameAvailability(stringValue);
    if (!isAvailable) {
      return 'Username is already taken';
    }
    
    return null;
  },
}
```

## Migration from Traditional Forms

### Before (Traditional Approach)

```dart
class _MyFormState extends State<MyForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _nameHasError = false;
  bool _emailHasError = false;
  
  void _onNameChanged(String value) {
    _nameHasError = value.isEmpty;
    _onValidate();
  }
  
  void _onValidate() {
    final nameHasError = _nameController.text.isEmpty;
    final emailHasError = !EmailValidator.validate(_emailController.text);
    // ... lots of repetitive code
  }
}
```

### After (with FormKit)

```dart
FormKit<Map<String, dynamic>>(
  config: FormKitConfig<Map<String, dynamic>>(
    initialValues: const {'name': '', 'email': ''},
    validationSchema: (values) => {
      'name': (value) => (value as String?)?.isEmpty == true ? 'Required' : null,
      'email': (value) => !EmailValidator.validate(value as String) ? 'Invalid' : null,
    },
  ),
  builder: (context, state) => Column(
    children: [
      FormKitField<String>(
        name: 'name',
        builder: (field) => TextField(
          onChanged: field.onChange,
          decoration: InputDecoration(
            errorText: field.touched ? field.error : null,
          ),
        ),
      ),
      FormKitField<String>(
        name: 'email', 
        builder: (field) => TextField(
          onChanged: field.onChange,
          decoration: InputDecoration(
            errorText: field.touched ? field.error : null,
          ),
        ),
      ),
    ],
  ),
)
```

## Benefits

1. **Less Code** - Automatic validation and error handling
2. **Better DX** - Simpler API for developers
3. **Testability** - Easier to test form logic
4. **Consistency** - Single approach for all forms
5. **Type Safety** - Full Dart type support
6. **Performance** - Optimized rebuilds

## Examples

See the `example/` directory for complete usage examples.

## Contributing

Contributions are welcome! Please read our [contributing guide](CONTRIBUTING.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.