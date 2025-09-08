import 'package:flutter_test/flutter_test.dart';
import 'package:formkit/formkit.dart';

void main() {
  group('FormKitController', () {
    late FormKitController<String> controller;

    setUp(() {
      controller = FormKitController<String>(
        config: FormKitConfig<String>(
          initialValues: const {'name': '', 'email': ''},
          validationSchema: (values) => {
            'name': (value) => (value as String?)?.isEmpty ?? false ? 'Required' : null,
            'email': (value) => (value as String?)?.isEmpty ?? false ? 'Required' : null,
          },
        ),
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with initial values', () {
      expect(controller.values, equals({'name': '', 'email': ''}));
      expect(controller.isValid, isTrue);
      expect(controller.isSubmitting, isFalse);
      expect(controller.isValidating, isFalse);
    });

    test('should update field value', () {
      controller.setFieldValue('name', 'John');
      expect(controller.getValue('name'), equals('John'));
    });

    test('should validate field on change', () async {
      controller.setFieldValue('name', '');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(controller.getError('name'), equals('Required'));
      expect(controller.isValid, isFalse);
    });

    test('should submit form successfully', () async {
      bool submitted = false;
      controller = FormKitController<String>(
        config: FormKitConfig<String>(
          initialValues: const {'name': 'John', 'email': 'john@example.com'},
          onSubmit: (values) async {
            submitted = true;
          },
        ),
      );

      await controller.submit();
      expect(submitted, isTrue);
    });

    test('should reset form to initial values', () {
      controller.setFieldValue('name', 'John');
      controller.setFieldValue('email', 'john@example.com');
      controller.reset();

      expect(controller.values, equals({'name': '', 'email': ''}));
      expect(controller.errors.isEmpty, isTrue);
      expect(controller.touched.isEmpty, isTrue);
      expect(controller.dirty.isEmpty, isTrue);
    });

    test('should track dirty state correctly', () {
      // Initially no fields should be dirty
      expect(controller.isDirty, isFalse);
      expect(controller.isFieldDirty('name'), isFalse);
      expect(controller.isFieldDirty('email'), isFalse);

      // Set a field value different from initial
      controller.setFieldValue('name', 'John');
      expect(controller.isDirty, isTrue);
      expect(controller.isFieldDirty('name'), isTrue);
      expect(controller.isFieldDirty('email'), isFalse);
      expect(controller.dirtyFields, contains('name'));
      expect(controller.dirtyValues, equals({'name': 'John'}));

      // Set field back to initial value
      controller.setFieldValue('name', '');
      expect(controller.isDirty, isFalse);
      expect(controller.isFieldDirty('name'), isFalse);
    });

    test('should reset specific field', () {
      controller.setFieldValue('name', 'John');
      controller.setFieldValue('email', 'john@example.com');
      controller.setFieldTouched('name', true);
      controller.setFieldError('name', 'Some error');

      controller.resetField('name');

      expect(controller.getValue('name'), equals(''));
      expect(controller.isFieldDirty('name'), isFalse);
      expect(controller.getTouched('name'), isFalse);
      expect(controller.getError('name'), isNull);

      // Other field should remain unchanged
      expect(controller.getValue('email'), equals('john@example.com'));
      expect(controller.isFieldDirty('email'), isTrue);
    });

    test('should update dirty state when setting values', () {
      controller.setValues({'name': 'John', 'email': 'john@example.com'});

      expect(controller.isDirty, isTrue);
      expect(controller.isFieldDirty('name'), isTrue);
      expect(controller.isFieldDirty('email'), isTrue);
      expect(controller.dirtyFields, containsAll(['name', 'email']));
    });
  });

  group('FormKitFieldState', () {
    test('should create field state with correct properties', () {
      final fieldState = FormKitFieldState<String>(
        value: 'test',
        onChange: (value) {},
        onBlur: () {},
        error: 'Error message',
        touched: true,
        hasError: true,
      );

      expect(fieldState.value, equals('test'));
      expect(fieldState.error, equals('Error message'));
      expect(fieldState.touched, isTrue);
      expect(fieldState.hasError, isTrue);
    });
  });

  group('FormKitConfig', () {
    test('should create config with default values', () {
      const config = FormKitConfig<String>(initialValues: {'name': ''});

      expect(config.initialValues, equals({'name': ''}));
      expect(config.validateOnChange, isTrue);
      expect(config.validateOnBlur, isTrue);
      expect(config.enableReinitialize, isFalse);
    });
  });
}
