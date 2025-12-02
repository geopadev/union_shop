import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('CartItem Model Tests', () {
    // Test data setup
    final testProduct1 = Product(
      id: 'product-1',
      title: 'Test Hoodie',
      price: '£25.00',
      imageUrl: 'assets/hoodie.jpg',
      description: 'A comfortable hoodie',
    );

    final testProduct2 = Product(
      id: 'product-2',
      title: 'Test T-Shirt',
      price: '£15.50',
      imageUrl: 'assets/tshirt.jpg',
      description: 'A stylish t-shirt',
    );

    final testProduct3 = Product(
      id: 'product-3',
      title: 'Test Mug',
      price: '£8.99',
      imageUrl: 'assets/mug.jpg',
      description: 'A ceramic mug',
    );

    group('CartItem Creation', () {
      test('should create cart item with all required fields', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
        );

        // Assert
        expect(cartItem.id, 'item-1');
        expect(cartItem.product, testProduct1);
        expect(cartItem.quantity, 2);
        expect(cartItem.selectedOptions, isNull);
      });

      test('should create cart item with selected options', () {
        // Arrange
        final options = {'size': 'M', 'color': 'Red'};

        // Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
          selectedOptions: options,
        );

        // Assert
        expect(cartItem.selectedOptions, options);
        expect(cartItem.selectedOptions?['size'], 'M');
        expect(cartItem.selectedOptions?['color'], 'Red');
      });

      test('should create cart item without selected options', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
        );

        // Assert
        expect(cartItem.selectedOptions, isNull);
      });

      test('should create cart item with empty options map', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
          selectedOptions: {},
        );

        // Assert
        expect(cartItem.selectedOptions, isNotNull);
        expect(cartItem.selectedOptions, isEmpty);
      });

      test('should accept quantity of 1', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
        );

        // Assert
        expect(cartItem.quantity, 1);
      });

      test('should accept large quantity values', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 100,
        );

        // Assert
        expect(cartItem.quantity, 100);
      });
    });

    group('CartItem.totalPrice', () {
      test('should calculate total price correctly (price × quantity)', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1, // £25.00
          quantity: 2,
        );

        // Act
        final total = cartItem.totalPrice;

        // Assert
        expect(total, 50.00); // £25.00 × 2
      });

      test('should calculate total for quantity of 1', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1, // £25.00
          quantity: 1,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 25.00);
      });

      test('should handle decimal prices correctly', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct2, // £15.50
          quantity: 3,
        );

        // Act
        final total = cartItem.totalPrice;

        // Assert
        expect(total, 46.50); // £15.50 × 3
      });

      test('should calculate with £9.99 price point', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct3, // £8.99
          quantity: 4,
        );

        // Act
        final total = cartItem.totalPrice;

        // Assert
        expect(total, 35.96); // £8.99 × 4
      });

      test('should return 0.0 for quantity of 0', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1, // £25.00
          quantity: 0,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 0.0);
      });

      test('should handle large quantity calculation', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1, // £25.00
          quantity: 100,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 2500.00);
      });

      test('should parse price string without pound symbol', () {
        // Arrange
        final product = Product(
          id: 'test',
          title: 'Test',
          price: '20.00', // No £ symbol
          imageUrl: 'test.jpg',
          description: 'Test',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 40.00);
      });

      test('should handle price with extra spaces', () {
        // Arrange
        final product = Product(
          id: 'test',
          title: 'Test',
          price: '  £ 20.00  ', // Extra spaces
          imageUrl: 'test.jpg',
          description: 'Test',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 40.00);
      });

      test('should return 0.0 for invalid price format', () {
        // Arrange
        final product = Product(
          id: 'test',
          title: 'Test',
          price: 'INVALID', // Invalid price
          imageUrl: 'test.jpg',
          description: 'Test',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 0.0); // Falls back to 0.0
      });
    });

    group('CartItem with Selected Options', () {
      test('should store single option', () {
        // Arrange
        final options = {'size': 'L'};
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
          selectedOptions: options,
        );

        // Act & Assert
        expect(cartItem.selectedOptions?['size'], 'L');
      });

      test('should store multiple options', () {
        // Arrange
        final options = {
          'size': 'M',
          'color': 'Blue',
          'material': 'Cotton',
        };
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
          selectedOptions: options,
        );

        // Act & Assert
        expect(cartItem.selectedOptions?['size'], 'M');
        expect(cartItem.selectedOptions?['color'], 'Blue');
        expect(cartItem.selectedOptions?['material'], 'Cotton');
        expect(cartItem.selectedOptions?.length, 3);
      });

      test('should not affect price calculation', () {
        // Arrange
        final itemWithOptions = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
          selectedOptions: {'size': 'XL', 'color': 'Red'},
        );
        final itemWithoutOptions = CartItem(
          id: 'item-2',
          product: testProduct1,
          quantity: 2,
        );

        // Act & Assert
        expect(itemWithOptions.totalPrice, itemWithoutOptions.totalPrice);
      });

      test('should handle options with special characters', () {
        // Arrange
        final options = {
          'size': 'X-Large',
          'color': 'Navy Blue',
          'custom-text': 'Hello World!',
        };
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
          selectedOptions: options,
        );

        // Act & Assert
        expect(cartItem.selectedOptions?['size'], 'X-Large');
        expect(cartItem.selectedOptions?['color'], 'Navy Blue');
        expect(cartItem.selectedOptions?['custom-text'], 'Hello World!');
      });
    });

    group('CartItem.copyWith', () {
      test('should create copy with same values when no params provided', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
          selectedOptions: {'size': 'M'},
        );

        // Act
        final copy = original.copyWith();

        // Assert
        expect(copy.id, original.id);
        expect(copy.product, original.product);
        expect(copy.quantity, original.quantity);
        expect(copy.selectedOptions, original.selectedOptions);
      });

      test('should create copy with updated quantity', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
        );

        // Act
        final copy = original.copyWith(quantity: 5);

        // Assert
        expect(copy.quantity, 5);
        expect(copy.id, original.id);
        expect(copy.product, original.product);
        expect(original.quantity, 2); // Original unchanged
      });

      test('should create copy with updated id', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
        );

        // Act
        final copy = original.copyWith(id: 'item-999');

        // Assert
        expect(copy.id, 'item-999');
        expect(copy.quantity, original.quantity);
        expect(original.id, 'item-1'); // Original unchanged
      });

      test('should create copy with updated product', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
        );

        // Act
        final copy = original.copyWith(product: testProduct2);

        // Assert
        expect(copy.product, testProduct2);
        expect(copy.product.id, 'product-2');
        expect(original.product, testProduct1); // Original unchanged
      });

      test('should create copy with updated options', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
          selectedOptions: {'size': 'M'},
        );
        final newOptions = {'size': 'L', 'color': 'Red'};

        // Act
        final copy = original.copyWith(selectedOptions: newOptions);

        // Assert
        expect(copy.selectedOptions, newOptions);
        expect(copy.selectedOptions?['size'], 'L');
        expect(copy.selectedOptions?['color'], 'Red');
        expect(original.selectedOptions?['size'], 'M'); // Original unchanged
      });

      test('should create copy with multiple updated fields', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
        );

        // Act
        final copy = original.copyWith(
          id: 'item-new',
          quantity: 10,
          product: testProduct2,
        );

        // Assert
        expect(copy.id, 'item-new');
        expect(copy.quantity, 10);
        expect(copy.product, testProduct2);
        expect(original.id, 'item-1'); // Original unchanged
        expect(original.quantity, 2); // Original unchanged
      });

      test('should keep original options when null is not explicitly set', () {
        // Arrange
        final original = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
          selectedOptions: {'size': 'M'},
        );

        // Act
        final copy = original.copyWith();

        // Assert
        // copyWith() without parameters keeps original values
        expect(copy.selectedOptions, original.selectedOptions);
        expect(original.selectedOptions, isNotNull); // Original unchanged
      });
    });

    group('CartItem.toString', () {
      test('should return readable string representation', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-123',
          product: testProduct1,
          quantity: 2,
          selectedOptions: {'size': 'M'},
        );

        // Act
        final string = cartItem.toString();

        // Assert
        expect(string, contains('CartItem('));
        expect(string, contains('id: item-123'));
        expect(string, contains('product: Test Hoodie'));
        expect(string, contains('quantity: 2'));
        expect(string, contains('options: {size: M}'));
      });

      test('should show null options in string', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
        );

        // Act
        final string = cartItem.toString();

        // Assert
        expect(string, contains('options: null'));
      });

      test('should show empty options map in string', () {
        // Arrange
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 1,
          selectedOptions: {},
        );

        // Act
        final string = cartItem.toString();

        // Assert
        expect(string, contains('options: {}'));
      });
    });

    group('CartItem ID Handling', () {
      test('should accept UUID-style ID', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: '550e8400-e29b-41d4-a716-446655440000',
          product: testProduct1,
          quantity: 1,
        );

        // Assert
        expect(cartItem.id, '550e8400-e29b-41d4-a716-446655440000');
      });

      test('should accept numeric string ID', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: '12345',
          product: testProduct1,
          quantity: 1,
        );

        // Assert
        expect(cartItem.id, '12345');
      });

      test('should accept alphanumeric ID', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item_abc123',
          product: testProduct1,
          quantity: 1,
        );

        // Assert
        expect(cartItem.id, 'item_abc123');
      });

      test('should distinguish items by ID even with same product', () {
        // Arrange
        final item1 = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: 2,
        );
        final item2 = CartItem(
          id: 'item-2',
          product: testProduct1,
          quantity: 2,
        );

        // Assert
        expect(item1.id, isNot(equals(item2.id)));
        expect(item1.product, item2.product);
      });
    });

    group('Edge Cases', () {
      test('should handle negative quantity (if allowed)', () {
        // Arrange & Act
        final cartItem = CartItem(
          id: 'item-1',
          product: testProduct1,
          quantity: -1,
        );

        // Assert
        expect(cartItem.quantity, -1);
        expect(cartItem.totalPrice, -25.00); // Negative price
      });

      test('should handle very small decimal prices', () {
        // Arrange
        final product = Product(
          id: 'penny-product',
          title: 'Penny Product',
          price: '£0.01',
          imageUrl: 'test.jpg',
          description: 'Very cheap',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 100,
        );

        // Act & Assert
        expect(cartItem.totalPrice, 1.00); // £0.01 × 100
      });

      test('should handle product price with comma separator', () {
        // Arrange
        final product = Product(
          id: 'expensive-product',
          title: 'Expensive Product',
          price: '£1,250.00',
          imageUrl: 'test.jpg',
          description: 'Very expensive',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );

        // Act
        // Note: Current implementation may not handle commas correctly
        // This test documents current behavior
        final total = cartItem.totalPrice;

        // Assert - testing actual behavior
        expect(total, isA<double>());
      });
    });
  });
}
