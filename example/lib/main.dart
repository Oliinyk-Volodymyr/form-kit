import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:formkit/formkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormKit Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const UserFormExample(),
    );
  }
}

class UserFormExample extends StatelessWidget {
  const UserFormExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('FormKit Example'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormKit<String>(
          config: FormKitConfig<String>(
            initialValues: const {'name': '', 'email': '', 'phone': ''},
            validationSchema: (values) => {
              'name': (dynamic value) {
                final stringValue = value as String?;
                if (stringValue == null || stringValue.isEmpty) {
                  return 'Name is required';
                }
                if (stringValue.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              'email': (dynamic value) {
                final stringValue = value as String?;
                if (stringValue == null || stringValue.isEmpty) {
                  return 'Email is required';
                }
                if (!EmailValidator.validate(stringValue)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              'phone': (dynamic value) {
                final stringValue = value as String?;
                if (stringValue != null && stringValue.isNotEmpty && stringValue.length < 10) {
                  return 'Phone number must be at least 10 digits';
                }
                return null;
              },
            },
            onSubmit: (values) async {
              // Simulate form submission
              await Future<void>.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form submitted: ${values.toString()}'), backgroundColor: Colors.green),
                );
              }
            },
          ),
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'User Registration Form',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Name field
                  FormKitField<String, String>(
                    fieldKey: 'name',
                    builder: (fieldState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            errorText: !fieldState.touched ? fieldState.error : null,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: fieldState.onChange,
                          onTapOutside: (_) => fieldState.onBlur(),
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email field
                  FormKitField<String, String>(
                    fieldKey: 'email',
                    builder: (fieldState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            errorText: !fieldState.touched ? fieldState.error : null,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: fieldState.onChange,
                          onTapOutside: (_) => fieldState.onBlur(),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Phone field
                  FormKitField<String, String>(
                    fieldKey: 'phone',
                    builder: (fieldState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter your phone number',
                            errorText: !fieldState.touched ? fieldState.error : null,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: fieldState.onChange,
                          onTapOutside: (_) => fieldState.onBlur(),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            FormKitProvider.of<Map<String, dynamic>>(context).reset();
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormKitSubmitButton(child: Text(state.isSubmitting ? 'Submitting...' : 'Submit')),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Form state display
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Form State:', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          Text('Values: ${state.values}'),
                          Text('Errors: ${state.errors}'),
                          Text('Touched: ${state.touched}'),
                          Text('Is Valid: ${state.isValid}'),
                          Text('Is Submitting: ${state.isSubmitting}'),
                          Text('Is Validating: ${state.isValidating}'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Form errors display
                  FormKitErrors(style: const TextStyle(color: Colors.red, fontSize: 14)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

