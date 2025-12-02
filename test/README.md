# Testing Documentation

## Overview

This project uses comprehensive testing following MVVM architecture principles. Tests are organized by layer: Models, ViewModels, Repositories, Services, Widgets, and Views.

## Test Structure

```
test/
├── models/              # Data class tests
├── view_models/         # Business logic tests (PRIORITY)
├── repositories/        # Data access layer tests
├── services/           # Service layer tests
├── widgets/            # UI component tests
│   ├── shared/        # Shared widget tests
│   └── home/          # Home-specific widget tests
├── views/              # Integration tests
│   └── auth/          # Authentication view tests
└── helpers/           # Test utilities
    ├── mock_annotations.dart  # Mock generation setup
    └── test_helpers.dart      # Test helper functions
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Specific Test File
```bash
flutter test test/view_models/cart_view_model_test.dart
```

### Run Tests Matching Pattern
```bash
flutter test --name "CartViewModel"
```

### Generate Mocks
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing Dependencies

- **flutter_test**: Flutter's testing framework
- **mockito**: Mocking library for unit tests
- **build_runner**: Code generation for mocks
- **fake_cloud_firestore**: Mock Firestore for testing
- **firebase_auth_mocks**: Mock Firebase Auth for testing

## Testing Conventions

### Naming Conventions
- Test files: `<filename>_test.dart`
- Test groups: `group('ClassName', () {...})`
- Individual tests: `test('should do something', () {...})`

### Test Structure (AAA Pattern)
```dart
test('should add item to cart', () {
  // Arrange - Setup test data and mocks
  final mockRepo = MockCartRepository();
  final viewModel = CartViewModel(mockRepo);
  final product = TestHelpers.createTestProduct();
  
  // Act - Execute the code being tested
  await viewModel.addToCart(product, 1);
  
  // Assert - Verify the results
  expect(viewModel.totalItems, 1);
  verify(mockRepo.addItem(product, 1)).called(1);
});
```

### Mock Setup
```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Use generated mocks
final mockRepo = MockCartRepository();

// Setup mock behavior
when(mockRepo.getCart()).thenAnswer((_) async => Cart(items: []));

// Verify mock was called
verify(mockRepo.getCart()).called(1);
```

## Testing Priorities

### Priority 1: ViewModel Tests (70%)
- Focus on business logic
- Most bugs occur here
- Fast execution (no UI)
- Easy to mock dependencies

### Priority 2: Model Tests (10%)
- Test data calculations
- Test getters and methods
- Test validation logic

### Priority 3: Widget Tests (15%)
- Test UI components
- Test user interactions
- Test state changes

### Priority 4: Integration Tests (5%)
- Test complete user flows
- Test view interactions
- End-to-end scenarios

## Test Helpers

### TestHelpers Class
Provides factory methods for creating test data:

```dart
// Create test product
final product = TestHelpers.createTestProduct(
  id: 'test-1',
  title: 'Test Product',
  price: '£20.00',
);

// Create test cart item
final cartItem = TestHelpers.createTestCartItem(
  product: product,
  quantity: 2,
);

// Create test cart
final cart = TestHelpers.createTestCart(
  items: [cartItem],
);
```

## Coverage Goals

- **Overall Coverage**: 70%+
- **ViewModels**: 90%+
- **Models**: 80%+
- **Repositories**: 70%+
- **Widgets**: 60%+

## Common Testing Patterns

### Testing Async Operations
```dart
test('should load products asynchronously', () async {
  when(mockRepo.fetchAll()).thenAnswer((_) async => [product1, product2]);
  
  await viewModel.refreshProducts();
  
  expect(viewModel.products.length, 2);
});
```

### Testing Loading States
```dart
test('should set isLoading during operation', () async {
  when(mockRepo.getCart()).thenAnswer((_) async {
    await Future.delayed(Duration(milliseconds: 100));
    return Cart(items: []);
  });
  
  final future = viewModel.refreshCart();
  expect(viewModel.isLoading, true);
  
  await future;
  expect(viewModel.isLoading, false);
});
```

### Testing Error Handling
```dart
test('should handle repository errors gracefully', () async {
  when(mockRepo.addItem(any, any)).thenThrow(Exception('Network error'));
  
  expect(() => viewModel.addToCart(product, 1), throwsException);
});
```

## Troubleshooting

### Issue: Mocks not found
**Solution**: Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: Tests fail with async errors
**Solution**: Use `await tester.pumpAndSettle()` in widget tests

### Issue: Firebase errors in tests
**Solution**: Use mocks (fake_cloud_firestore, firebase_auth_mocks) instead of real Firebase

### Issue: Provider not found in widget tests
**Solution**: Wrap test widget with proper Provider setup

## Best Practices

✅ **DO:**
- Write tests for ViewModels first
- Mock all external dependencies
- Test edge cases and error scenarios
- Use meaningful test descriptions
- Keep tests fast and isolated
- Follow AAA pattern (Arrange, Act, Assert)

❌ **DON'T:**
- Test framework code (Provider, GoRouter)
- Test Firebase/Firestore directly
- Make tests dependent on each other
- Test implementation details
- Skip error handling tests

## Resources

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [MVVM Testing Best Practices](https://developer.android.com/topic/architecture/testing)
