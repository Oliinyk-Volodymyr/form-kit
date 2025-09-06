# Contributing to FormKit

Thank you for your interest in contributing to FormKit! This document provides guidelines and information for contributors.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature or bugfix
4. Make your changes
5. Add tests for your changes
6. Ensure all tests pass
7. Submit a pull request

## Development Setup

1. Install Flutter SDK (>=3.10.0)
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run tests:
   ```bash
   flutter test
   ```
4. Run the example app:
   ```bash
   cd example
   flutter run
   ```

## Code Style

- Follow the existing code style
- Use `dart format` to format your code
- Follow the linting rules defined in `analysis_options.yaml`
- Write clear and concise commit messages

## Testing

- Write tests for new features
- Ensure all existing tests pass
- Aim for high test coverage
- Test both happy path and edge cases

## Pull Request Process

1. Ensure your code follows the project's style guidelines
2. Add or update tests as needed
3. Update documentation if necessary
4. Ensure all CI checks pass
5. Request review from maintainers

## Reporting Issues

When reporting issues, please include:
- Flutter version
- FormKit version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Code samples if applicable

## Feature Requests

For feature requests, please:
- Check if the feature already exists
- Provide a clear description
- Explain the use case
- Consider the impact on existing users

## License

By contributing to FormKit, you agree that your contributions will be licensed under the MIT License.

