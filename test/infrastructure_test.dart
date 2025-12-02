import 'package:flutter_test/flutter_test.dart';

/// Simple test to verify test infrastructure is working
void main() {
  group('Test Infrastructure', () {
    test('basic test should pass', () {
      expect(1 + 1, 2);
    });

    test('string comparison should work', () {
      const greeting = 'Hello, World!';
      expect(greeting, 'Hello, World!');
    });

    test('list operations should work', () {
      final list = [1, 2, 3];
      expect(list.length, 3);
      expect(list.first, 1);
      expect(list.last, 3);
    });
  });
}
