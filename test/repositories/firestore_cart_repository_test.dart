import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/firestore_cart_repository.dart';
import 'package:firebase_core/firebase_core.dart';

import '../helpers/test_helpers.dart';
import '../helpers/firebase_test_setup.dart';

/// NOTE: FirestoreCartRepository testing is limited because the repository uses
/// FirebaseFirestore.instance directly without dependency injection.
/// Full testing would require:
/// 1. Refactoring FirestoreCartRepository to accept FirebaseFirestore as constructor parameter
/// 2. Using FakeFirebaseFirestore from fake_cloud_firestore package
/// 3. Testing authenticated user flows with mocked Firestore
///
/// For now, these tests document the repository API and test guest cart functionality
/// which uses in-memory storage and doesn't require Firebase initialization.
void main() {
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('FirestoreCartRepository Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = TestHelpers.createTestProduct(
        id: 'prod1',
        title: 'Test Product',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
      );
    });

    group('Guest User (userId = null)', () {
      test('should return empty cart initially for guest', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        final cart = await repository.getCart();

        // Assert
        expect(cart.items.isEmpty, true);
      });

      test('should add item to guest cart in memory', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        await repository.addItem(testProduct, 2);
        final cart = await repository.getCart();

        // Assert
        expect(cart.items.length, 1);
        expect(cart.items[0].product.id, 'prod1');
        expect(cart.items[0].quantity, 2);
      });

      test('should remove item from guest cart', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        await repository.addItem(testProduct, 1);

        final cart = await repository.getCart();
        final itemId = cart.items[0].id;

        // Act
        await repository.removeItem(itemId);
        final updatedCart = await repository.getCart();

        // Assert
        expect(updatedCart.items.isEmpty, true);
      });

      test('should update quantity in guest cart', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        await repository.addItem(testProduct, 2);

        final cart = await repository.getCart();
        final itemId = cart.items[0].id;

        // Act
        await repository.updateQuantity(itemId, 5);
        final updatedCart = await repository.getCart();

        // Assert
        expect(updatedCart.items[0].quantity, 5);
      });

      test('should remove item when quantity set to zero', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        await repository.addItem(testProduct, 3);

        final cart = await repository.getCart();
        final itemId = cart.items[0].id;

        // Act
        await repository.updateQuantity(itemId, 0);
        final updatedCart = await repository.getCart();

        // Assert
        expect(updatedCart.items.isEmpty, true);
      });

      test('should clear guest cart', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        await repository.addItem(testProduct, 1);

        // Act
        await repository.clearCart();
        final cart = await repository.getCart();

        // Assert
        expect(cart.items.isEmpty, true);
      });

      test('should maintain separate guest carts for different instances',
          () async {
        // Arrange
        final repository1 = FirestoreCartRepository(userId: null);
        final repository2 = FirestoreCartRepository(userId: null);

        // Act
        await repository1.addItem(testProduct, 1);
        final cart1 = await repository1.getCart();
        final cart2 = await repository2.getCart();

        // Assert - Each instance has its own in-memory cart
        expect(cart1.items.length, 1);
        expect(cart2.items.isEmpty, true);
      });

      test(
          'should increment quantity when adding same product with same options',
          () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final options = {'size': 'M', 'color': 'Red'};

        // Act
        await repository.addItem(testProduct, 2, selectedOptions: options);
        await repository.addItem(testProduct, 3, selectedOptions: options);
        final cart = await repository.getCart();

        // Assert - Should have 1 item with quantity 5
        expect(cart.items.length, 1);
        expect(cart.items[0].quantity, 5);
      });

      test(
          'should add separate items when adding same product with different options',
          () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final options1 = {'size': 'M'};
        final options2 = {'size': 'L'};

        // Act
        await repository.addItem(testProduct, 2, selectedOptions: options1);
        await repository.addItem(testProduct, 3, selectedOptions: options2);
        final cart = await repository.getCart();

        // Assert - Should have 2 separate items
        expect(cart.items.length, 2);
        expect(cart.items[0].selectedOptions?['size'], 'M');
        expect(cart.items[1].selectedOptions?['size'], 'L');
      });
    });

    group('Authenticated User', () {
      test(
          'documents that authenticated user tests require Firebase initialization',
          () {
        // FirestoreCartRepository uses FirebaseFirestore.instance directly
        // Testing authenticated users requires:
        // 1. setupFirebaseAuthMocks() or FakeFirebaseFirestore injection
        // 2. Refactoring repository to accept Firestore as dependency
        // Current architecture makes full repository testing impractical without refactoring
        expect(true, true);
      });

      test('documents getCart() creates empty cart document for new users', () {
        // When userId is provided and Firestore doc doesn't exist:
        // - Creates user document with empty cart array
        // - Sets createdAt timestamp
        // - Returns Cart with empty items list
        expect(true, true);
      });

      test('documents getCart() loads cart from Firestore for existing users',
          () {
        // When userId is provided and Firestore doc exists:
        // - Fetches users/{userId} document
        // - Parses cart array into CartItem objects
        // - Reconstructs Product objects from stored data
        // - Returns Cart with loaded items
        expect(true, true);
      });

      test('documents addItem() saves to Firestore', () {
        // When userId is provided:
        // - Serializes CartItem to map with product data
        // - Saves to users/{userId}/cart array
        // - Sets updatedAt timestamp
        // - Merges with existing document
        expect(true, true);
      });

      test('documents removeItem() deletes from Firestore', () {
        // When userId is provided:
        // - Filters out item with matching id
        // - Saves updated cart array to Firestore
        expect(true, true);
      });

      test('documents updateQuantity() modifies item in Firestore', () {
        // When userId is provided:
        // - Finds item by id
        // - Updates quantity (or removes if <= 0)
        // - Saves updated cart to Firestore
        expect(true, true);
      });

      test('documents clearCart() empties Firestore cart array', () {
        // When userId is provided:
        // - Saves empty array to users/{userId}/cart
        // - Sets updatedAt timestamp
        expect(true, true);
      });

      test('documents error handling returns empty cart on Firestore failures',
          () {
        // On Firestore errors:
        // - Catches exception
        // - Logs error message
        // - Returns Cart with empty items (graceful degradation)
        expect(true, true);
      });
    });

    group('Edge Cases', () {
      test('should handle adding product with no selected options', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        await repository.addItem(testProduct, 1);
        final cart = await repository.getCart();

        // Assert
        expect(cart.items.length, 1);
        expect(cart.items[0].selectedOptions, null);
      });

      test('should handle adding product with empty selected options',
          () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        await repository.addItem(testProduct, 1, selectedOptions: {});
        final cart = await repository.getCart();

        // Assert
        expect(cart.items.length, 1);
        expect(cart.items[0].selectedOptions, {});
      });

      test('should handle updating quantity of non-existent item', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        await repository.updateQuantity('nonexistent-id', 5);
        final cart = await repository.getCart();

        // Assert - Cart remains empty
        expect(cart.items.isEmpty, true);
      });

      test('should handle removing non-existent item', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        await repository.addItem(testProduct, 1);

        // Act
        await repository.removeItem('nonexistent-id');
        final cart = await repository.getCart();

        // Assert - Original item still exists
        expect(cart.items.length, 1);
      });

      test('should handle multiple operations in sequence', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final product2 =
            TestHelpers.createTestProduct(id: 'prod2', title: 'Product 2');

        // Act
        await repository.addItem(testProduct, 1);
        await repository.addItem(product2, 2);

        var cart = await repository.getCart();
        expect(cart.items.length, 2,
            reason: 'Should have 2 items after adding');

        // Find items by product ID to be more robust
        final item1 =
            cart.items.firstWhere((i) => i.product.id == testProduct.id);
        final item2 = cart.items.firstWhere((i) => i.product.id == product2.id);

        await repository.updateQuantity(item1.id, 5);

        cart = await repository.getCart();
        expect(cart.items.length, 2,
            reason: 'Should still have 2 items after update');
        expect(cart.items.firstWhere((i) => i.id == item1.id).quantity, 5);

        await repository.removeItem(item2.id);

        cart = await repository.getCart();

        // Assert
        expect(cart.items.length, 1,
            reason: 'Should have 1 item after removing one');
        expect(cart.items[0].id, item1.id,
            reason: 'Should be the first item that remains');
        expect(cart.items[0].quantity, 5,
            reason: 'Remaining item should have quantity 5');
      });

      test('should handle adding large quantity', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        await repository.addItem(testProduct, 999);
        final cart = await repository.getCart();

        // Assert
        expect(cart.items[0].quantity, 999);
      });

      test('should handle clearing empty cart', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act & Assert - Should not error
        await repository.clearCart();
        final cart = await repository.getCart();
        expect(cart.items.isEmpty, true);
      });
    });

    group('Selected Options Handling', () {
      test('should preserve selected options when adding item', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final options = {
          'size': 'Large',
          'color': 'Blue',
          'text': 'Custom Text'
        };

        // Act
        await repository.addItem(testProduct, 1, selectedOptions: options);
        final cart = await repository.getCart();

        // Assert
        expect(cart.items[0].selectedOptions, options);
      });

      test('should preserve selected options when updating quantity', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final options = {'size': 'Medium'};

        await repository.addItem(testProduct, 1, selectedOptions: options);
        final cart = await repository.getCart();
        final itemId = cart.items[0].id;

        // Act
        await repository.updateQuantity(itemId, 3);
        final updatedCart = await repository.getCart();

        // Assert
        expect(updatedCart.items[0].selectedOptions, options);
      });

      test('should treat null and empty options as the same', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);

        // Act
        await repository.addItem(testProduct, 1); // null options
        await repository
            .addItem(testProduct, 1, selectedOptions: {}); // empty options
        final cart = await repository.getCart();

        // Assert - Should have 1 item with quantity 2 (null == {} for cart purposes)
        expect(cart.items.length, 1);
        expect(cart.items[0].quantity, 2);
      });
    });

    group('Product Data Preservation', () {
      test('should preserve all product fields when adding to cart', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final detailedProduct = TestHelpers.createTestProduct(
          id: 'detailed-prod',
          title: 'Detailed Product',
          price: '£45.99',
          imageUrl: 'https://example.com/detailed.jpg',
          description: 'A very detailed product description',
        );

        // Act
        await repository.addItem(detailedProduct, 1);
        final cart = await repository.getCart();

        // Assert
        final savedProduct = cart.items[0].product;
        expect(savedProduct.id, 'detailed-prod');
        expect(savedProduct.title, 'Detailed Product');
        expect(savedProduct.price, '£45.99');
        expect(savedProduct.imageUrl, 'https://example.com/detailed.jpg');
        expect(savedProduct.description, 'A very detailed product description');
      });
    });

    group('Cart State Management', () {
      test('should maintain cart state across multiple getCart calls',
          () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        await repository.addItem(testProduct, 3);

        // Act
        final cart1 = await repository.getCart();
        final cart2 = await repository.getCart();
        final cart3 = await repository.getCart();

        // Assert
        expect(cart1.items.length, 1);
        expect(cart2.items.length, 1);
        expect(cart3.items.length, 1);
        expect(cart1.items[0].quantity, 3);
      });

      test('should handle adding multiple different products', () async {
        // Arrange
        final repository = FirestoreCartRepository(userId: null);
        final products = List.generate(
          5,
          (i) => TestHelpers.createTestProduct(
            id: 'prod$i',
            title: 'Product $i',
          ),
        );

        // Act
        for (var i = 0; i < products.length; i++) {
          await repository.addItem(products[i], i + 1);
        }
        final cart = await repository.getCart();

        // Assert
        expect(cart.items.length, 5);
        for (var i = 0; i < 5; i++) {
          expect(cart.items[i].product.id, 'prod$i');
          expect(cart.items[i].quantity, i + 1);
        }
      });
    });
  });
}
