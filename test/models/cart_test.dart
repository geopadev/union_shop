import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Cart Model Tests', () {
    // Test data setup
    final product1 = Product(
      id: 'test-1',
      title: 'Test Product 1',
      price: '£20.00',
      imageUrl: 'assets/test1.jpg',
      description: 'Test description 1',
    );

    final product2 = Product(
      id: 'test-2',
      title: 'Test Product 2',
      price: '£15.50',
      imageUrl: 'assets/test2.jpg',
      description: 'Test description 2',
    );

    final product3 = Product(
      id: 'test-3',
      title: 'Test Product 3',
      price: '£10.00',
      imageUrl: 'assets/test3.jpg',
      description: 'Test description 3',
    );

    final cartItem1 = CartItem(
      id: 'item-1',
      product: product1,
      quantity: 2, // £20.00 × 2 = £40.00
    );

    final cartItem2 = CartItem(
      id: 'item-2',
      product: product2,
      quantity: 1, // £15.50 × 1 = £15.50
    );

    final cartItem3 = CartItem(
      id: 'item-3',
      product: product3,
      quantity: 3, // £10.00 × 3 = £30.00
    );

    group('Cart Creation', () {
      test('should create empty cart with Cart.empty()', () {
        // Arrange & Act
        final cart = Cart.empty();

        // Assert
        expect(cart.items, isEmpty);
        expect(cart.isEmpty, true);
        expect(cart.isNotEmpty, false);
      });

      test('should create cart with items list', () {
        // Arrange & Act
        final cart = Cart(items: [cartItem1, cartItem2]);

        // Assert
        expect(cart.items.length, 2);
        expect(cart.isEmpty, false);
        expect(cart.isNotEmpty, true);
      });

      test('should create cart with empty items list', () {
        // Arrange & Act
        final cart = Cart(items: []);

        // Assert
        expect(cart.items, isEmpty);
        expect(cart.isEmpty, true);
      });
    });

    group('Cart.totalItems', () {
      test('should return 0 for empty cart', () {
        // Arrange
        final cart = Cart.empty();

        // Act & Assert
        expect(cart.totalItems, 0);
      });

      test('should return sum of all item quantities', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2, cartItem3]);

        // Act
        final total = cart.totalItems;

        // Assert
        expect(total, 6); // 2 + 1 + 3 = 6
      });

      test('should return correct total with single item', () {
        // Arrange
        final cart = Cart(items: [cartItem1]);

        // Act & Assert
        expect(cart.totalItems, 2);
      });

      test('should handle items with different quantities', () {
        // Arrange
        final item1 = CartItem(
          id: 'item-1',
          product: product1,
          quantity: 5,
        );
        final item2 = CartItem(
          id: 'item-2',
          product: product2,
          quantity: 10,
        );
        final cart = Cart(items: [item1, item2]);

        // Act & Assert
        expect(cart.totalItems, 15); // 5 + 10 = 15
      });
    });

    group('Cart.totalPrice', () {
      test('should return 0.0 for empty cart', () {
        // Arrange
        final cart = Cart.empty();

        // Act & Assert
        expect(cart.totalPrice, 0.0);
      });

      test('should calculate total price correctly with multiple items', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2]);

        // Act
        final total = cart.totalPrice;

        // Assert
        // cartItem1: £20.00 × 2 = £40.00
        // cartItem2: £15.50 × 1 = £15.50
        // Total: £55.50
        expect(total, 55.50);
      });

      test('should calculate total price with three items', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2, cartItem3]);

        // Act
        final total = cart.totalPrice;

        // Assert
        // cartItem1: £20.00 × 2 = £40.00
        // cartItem2: £15.50 × 1 = £15.50
        // cartItem3: £10.00 × 3 = £30.00
        // Total: £85.50
        expect(total, 85.50);
      });

      test('should handle single item cart', () {
        // Arrange
        final cart = Cart(items: [cartItem1]);

        // Act & Assert
        expect(cart.totalPrice, 40.00); // £20.00 × 2
      });

      test('should handle decimal prices correctly', () {
        // Arrange
        final product = Product(
          id: 'test-decimal',
          title: 'Decimal Product',
          price: '£9.99',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final item = CartItem(
          id: 'item-decimal',
          product: product,
          quantity: 3,
        );
        final cart = Cart(items: [item]);

        // Act & Assert
        expect(cart.totalPrice, 29.97); // £9.99 × 3
      });
    });

    group('Cart.isEmpty and Cart.isNotEmpty', () {
      test('isEmpty should return true for empty cart', () {
        // Arrange
        final cart = Cart.empty();

        // Act & Assert
        expect(cart.isEmpty, true);
        expect(cart.isNotEmpty, false);
      });

      test('isEmpty should return true for cart with empty items list', () {
        // Arrange
        final cart = Cart(items: []);

        // Act & Assert
        expect(cart.isEmpty, true);
        expect(cart.isNotEmpty, false);
      });

      test('isEmpty should return false for cart with items', () {
        // Arrange
        final cart = Cart(items: [cartItem1]);

        // Act & Assert
        expect(cart.isEmpty, false);
        expect(cart.isNotEmpty, true);
      });

      test('isNotEmpty should return true when cart has multiple items', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2, cartItem3]);

        // Act & Assert
        expect(cart.isNotEmpty, true);
        expect(cart.isEmpty, false);
      });
    });

    group('Cart.formattedTotal', () {
      test('should return "£0.00" for empty cart', () {
        // Arrange
        final cart = Cart.empty();

        // Act & Assert
        expect(cart.formattedTotal, '£0.00');
      });

      test('should format total price correctly with two decimal places', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2]);

        // Act
        final formatted = cart.formattedTotal;

        // Assert
        expect(formatted, '£55.50');
      });

      test('should format whole numbers with .00', () {
        // Arrange
        final product = Product(
          id: 'test-whole',
          title: 'Whole Number Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final item = CartItem(
          id: 'item-whole',
          product: product,
          quantity: 3,
        );
        final cart = Cart(items: [item]);

        // Act & Assert
        expect(cart.formattedTotal, '£30.00'); // £10 × 3
      });

      test('should handle decimal prices in formatted string', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2, cartItem3]);

        // Act & Assert
        expect(cart.formattedTotal, '£85.50');
      });

      test('should format single penny correctly', () {
        // Arrange
        final product = Product(
          id: 'test-penny',
          title: 'Penny Product',
          price: '£0.01',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final item = CartItem(
          id: 'item-penny',
          product: product,
          quantity: 5,
        );
        final cart = Cart(items: [item]);

        // Act & Assert
        expect(cart.formattedTotal, '£0.05');
      });
    });

    group('Cart.copyWith', () {
      test('should create copy with same items when no params provided', () {
        // Arrange
        final originalCart = Cart(items: [cartItem1, cartItem2]);

        // Act
        final copiedCart = originalCart.copyWith();

        // Assert
        expect(copiedCart.items.length, originalCart.items.length);
        expect(copiedCart.totalPrice, originalCart.totalPrice);
      });

      test('should create copy with new items', () {
        // Arrange
        final originalCart = Cart(items: [cartItem1]);
        final newItems = [cartItem2, cartItem3];

        // Act
        final copiedCart = originalCart.copyWith(items: newItems);

        // Assert
        expect(copiedCart.items.length, 2);
        expect(copiedCart.items, newItems);
        expect(originalCart.items.length, 1); // Original unchanged
      });

      test('should create copy with empty items list', () {
        // Arrange
        final originalCart = Cart(items: [cartItem1, cartItem2]);

        // Act
        final copiedCart = originalCart.copyWith(items: []);

        // Assert
        expect(copiedCart.isEmpty, true);
        expect(originalCart.isNotEmpty, true); // Original unchanged
      });
    });

    group('Cart.toString', () {
      test('should return readable string representation', () {
        // Arrange
        final cart = Cart(items: [cartItem1, cartItem2]);

        // Act
        final string = cart.toString();

        // Assert
        expect(string, contains('Cart('));
        expect(string, contains('items: 2'));
        expect(string, contains('totalItems: 3'));
        expect(string, contains('£55.50'));
      });

      test('should show empty cart correctly', () {
        // Arrange
        final cart = Cart.empty();

        // Act
        final string = cart.toString();

        // Assert
        expect(string, contains('Cart('));
        expect(string, contains('items: 0'));
        expect(string, contains('totalItems: 0'));
        expect(string, contains('£0.00'));
      });
    });

    group('Edge Cases', () {
      test('should handle cart with zero quantity items', () {
        // Arrange
        final zeroItem = CartItem(
          id: 'zero-item',
          product: product1,
          quantity: 0,
        );
        final cart = Cart(items: [zeroItem, cartItem1]);

        // Act & Assert
        expect(cart.totalItems, 2); // 0 + 2
        expect(cart.totalPrice, 40.00); // 0 + 40
      });

      test('should handle very large quantities', () {
        // Arrange
        final largeItem = CartItem(
          id: 'large-item',
          product: product1,
          quantity: 1000,
        );
        final cart = Cart(items: [largeItem]);

        // Act & Assert
        expect(cart.totalItems, 1000);
        expect(cart.totalPrice, 20000.00); // £20 × 1000
        expect(cart.formattedTotal, '£20000.00');
      });

      test('should handle multiple items of same product', () {
        // Arrange
        final item1 = CartItem(
          id: 'item-1',
          product: product1,
          quantity: 2,
        );
        final item2 = CartItem(
          id: 'item-2',
          product: product1, // Same product, different cart item
          quantity: 3,
        );
        final cart = Cart(items: [item1, item2]);

        // Act & Assert
        expect(cart.totalItems, 5); // 2 + 3
        expect(cart.totalPrice, 100.00); // £20×2 + £20×3
      });
    });
  });
}
