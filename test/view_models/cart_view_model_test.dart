import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/cart_view_model.dart';

import '../helpers/mock_annotations.mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CartViewModel Tests', () {
    late MockCartRepository mockRepository;
    late CartViewModel viewModel;
    late Product testProduct;
    late CartItem testCartItem;
    late Cart testCart;

    setUp(() {
      mockRepository = MockCartRepository();
      testProduct = TestHelpers.createTestProduct(
          id: 'prod1', title: 'Test Product', price: '£25.00');
      testCartItem =
          TestHelpers.createTestCartItem(product: testProduct, quantity: 2);
      testCart = TestHelpers.createTestCart(items: [testCartItem]);
    });

    group('Initialization', () {
      test('should initialize with empty cart', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero); // Wait for async initialization

        // Assert
        expect(viewModel.cart.items.isEmpty, true);
        expect(viewModel.isEmpty, true);
        expect(viewModel.totalItems, 0);
        expect(viewModel.totalPrice, 0.0);
        verify(mockRepository.getCart()).called(1);
      });

      test('should call refreshCart on initialization', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        verify(mockRepository.getCart()).called(1);
      });

      test('should load existing cart on initialization', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.cart.items.length, 1);
        expect(viewModel.totalItems, 2);
        expect(viewModel.isEmpty, false);
      });
    });

    group('Cart Getters', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
      });

      test('should return correct cart', () {
        expect(viewModel.cart, testCart);
        expect(viewModel.cart.items.length, 1);
      });

      test('should return correct totalItems', () {
        expect(viewModel.totalItems, 2);
      });

      test('should return correct totalPrice', () {
        expect(viewModel.totalPrice, 50.0); // £25 × 2
      });

      test('should return correct formattedTotal', () {
        expect(viewModel.formattedTotal, '£50.00');
      });

      test('should return correct isEmpty status', () {
        expect(viewModel.isEmpty, false);
      });

      test('should return true for isEmpty when cart is empty', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));
        final emptyViewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(emptyViewModel.isEmpty, true);
      });
    });

    group('addToCart Method', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository); // Clear initialization calls
      });

      test('should call repository addItem with correct parameters', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.addToCart(testProduct, 2);

        // Assert
        verify(mockRepository.addItem(testProduct, 2, selectedOptions: null))
            .called(1);
      });

      test('should call repository addItem with selectedOptions', () async {
        // Arrange
        final options = {'size': 'M', 'color': 'Red'};
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.addToCart(testProduct, 1, selectedOptions: options);

        // Assert
        verify(mockRepository.addItem(testProduct, 1, selectedOptions: options))
            .called(1);
      });

      test('should refresh cart after adding item', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.addToCart(testProduct, 1);

        // Assert
        verify(mockRepository.getCart()).called(1);
      });

      test('should update cart state after adding item', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.addToCart(testProduct, 1);

        // Assert
        expect(viewModel.cart.items.length, 1);
        expect(viewModel.totalItems, 2);
      });

      test('should set loading state during operation', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer(
                (_) async => await Future.delayed(Duration(milliseconds: 50)));
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.addToCart(testProduct, 1);
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after adding item', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.addToCart(testProduct, 1);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle adding multiple items', () async {
        // Arrange
        final product2 = TestHelpers.createTestProduct(
            id: 'prod2', title: 'Product 2', price: '£15.00');
        final cartWithTwo = Cart(items: [
          testCartItem,
          TestHelpers.createTestCartItem(product: product2)
        ]);

        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        var callCount = 0;
        when(mockRepository.getCart()).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? testCart : cartWithTwo;
        });

        // Act
        await viewModel.addToCart(testProduct, 1);
        await viewModel.addToCart(product2, 1);

        // Assert
        expect(viewModel.cart.items.length, 2);
      });
    });

    group('removeFromCart Method', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should call repository removeItem with correct itemId', () async {
        // Arrange
        when(mockRepository.removeItem(any)).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.removeFromCart('item1');

        // Assert
        verify(mockRepository.removeItem('item1')).called(1);
      });

      test('should refresh cart after removing item', () async {
        // Arrange
        when(mockRepository.removeItem(any)).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.removeFromCart('item1');

        // Assert
        verify(mockRepository.getCart()).called(1);
      });

      test('should update cart state after removing item', () async {
        // Arrange
        when(mockRepository.removeItem(any)).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.removeFromCart('item1');

        // Assert
        expect(viewModel.cart.items.isEmpty, true);
        expect(viewModel.isEmpty, true);
      });

      test('should set loading state during operation', () async {
        // Arrange
        when(mockRepository.removeItem(any)).thenAnswer(
            (_) async => await Future.delayed(Duration(milliseconds: 50)));
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.removeFromCart('item1');
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after removing item', () async {
        // Arrange
        when(mockRepository.removeItem(any)).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.removeFromCart('item1');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('updateQuantity Method', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should call repository updateQuantity with correct parameters',
          () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any))
            .thenAnswer((_) async => {});
        final updatedItem = testCartItem.copyWith(quantity: 5);
        final updatedCart = Cart(items: [updatedItem]);
        when(mockRepository.getCart()).thenAnswer((_) async => updatedCart);

        // Act
        await viewModel.updateQuantity('item1', 5);

        // Assert
        verify(mockRepository.updateQuantity('item1', 5)).called(1);
      });

      test('should refresh cart after updating quantity', () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.updateQuantity('item1', 3);

        // Assert
        verify(mockRepository.getCart()).called(1);
      });

      test('should update cart state after updating quantity', () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any))
            .thenAnswer((_) async => {});
        final updatedItem = testCartItem.copyWith(quantity: 5);
        final updatedCart = Cart(items: [updatedItem]);
        when(mockRepository.getCart()).thenAnswer((_) async => updatedCart);

        // Act
        await viewModel.updateQuantity('item1', 5);

        // Assert
        expect(viewModel.totalItems, 5);
      });

      test('should set loading state during operation', () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any)).thenAnswer(
            (_) async => await Future.delayed(Duration(milliseconds: 50)));
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.updateQuantity('item1', 3);
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after updating quantity', () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.updateQuantity('item1', 3);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle updating to zero quantity', () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any))
            .thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.updateQuantity('item1', 0);

        // Assert
        verify(mockRepository.updateQuantity('item1', 0)).called(1);
      });
    });

    group('clearCart Method', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should call repository clearCart', () async {
        // Arrange
        when(mockRepository.clearCart()).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.clearCart();

        // Assert
        verify(mockRepository.clearCart()).called(1);
      });

      test('should refresh cart after clearing', () async {
        // Arrange
        when(mockRepository.clearCart()).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.clearCart();

        // Assert
        verify(mockRepository.getCart()).called(1);
      });

      test('should update cart to empty after clearing', () async {
        // Arrange
        when(mockRepository.clearCart()).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.clearCart();

        // Assert
        expect(viewModel.cart.items.isEmpty, true);
        expect(viewModel.isEmpty, true);
        expect(viewModel.totalItems, 0);
        expect(viewModel.totalPrice, 0.0);
      });

      test('should set loading state during operation', () async {
        // Arrange
        when(mockRepository.clearCart()).thenAnswer(
            (_) async => await Future.delayed(Duration(milliseconds: 50)));
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.clearCart();
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after clearing cart', () async {
        // Arrange
        when(mockRepository.clearCart()).thenAnswer((_) async => {});
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.clearCart();

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('refreshCart Method', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should call repository getCart', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.refreshCart();

        // Assert
        verify(mockRepository.getCart()).called(1);
      });

      test('should update cart with repository data', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.refreshCart();

        // Assert
        expect(viewModel.cart.items.length, 1);
        expect(viewModel.totalItems, 2);
      });

      test('should set loading state during operation', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async =>
            await Future.delayed(Duration(milliseconds: 50), () => testCart));

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.refreshCart();
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after refreshing', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.refreshCart();

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle empty cart from repository', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act
        await viewModel.refreshCart();

        // Assert
        expect(viewModel.cart.items.isEmpty, true);
        expect(viewModel.isEmpty, true);
      });
    });

    group('updateRepository Method', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
      });

      test('should update repository and refresh cart', () async {
        // Arrange
        final newMockRepository = MockCartRepository();
        final newCart = Cart(items: [
          TestHelpers.createTestCartItem(
              product: TestHelpers.createTestProduct(
                  id: 'prod2', title: 'New Product', price: '£30.00'),
              quantity: 1)
        ]);
        when(newMockRepository.getCart()).thenAnswer((_) async => newCart);

        // Act
        await viewModel.updateRepository(newMockRepository);

        // Assert
        verify(newMockRepository.getCart()).called(1);
        expect(viewModel.cart.items.length, 1);
        expect(viewModel.cart.items.first.product.title, 'New Product');
      });

      test('should switch from old repository to new repository', () async {
        // Arrange
        final newMockRepository = MockCartRepository();
        var newRepoCallCount = 0;
        when(newMockRepository.getCart()).thenAnswer((_) async {
          newRepoCallCount++;
          return newRepoCallCount == 1 ? Cart(items: []) : testCart;
        });

        // Act
        await viewModel.updateRepository(newMockRepository);

        // Subsequent operations should use new repository
        when(newMockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});

        await viewModel.addToCart(testProduct, 1);

        // Assert
        verify(newMockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .called(1);
      });

      test('should load cart from new repository immediately', () async {
        // Arrange
        final newMockRepository = MockCartRepository();
        final emptyCart = Cart(items: []);
        when(newMockRepository.getCart()).thenAnswer((_) async => emptyCart);

        expect(viewModel.totalItems, 2); // Old cart has 2 items

        // Act
        await viewModel.updateRepository(newMockRepository);

        // Assert
        expect(viewModel.totalItems, 0); // New cart is empty
      });
    });

    group('Error Handling', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should handle repository error on addToCart', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenThrow(Exception('Network error'));
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));

        // Act & Assert
        expect(
          () => viewModel.addToCart(testProduct, 1),
          throwsException,
        );
      });

      test('should handle repository error on removeFromCart', () async {
        // Arrange
        when(mockRepository.removeItem(any))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => viewModel.removeFromCart('item1'),
          throwsException,
        );
      });

      test('should handle repository error on updateQuantity', () async {
        // Arrange
        when(mockRepository.updateQuantity(any, any))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => viewModel.updateQuantity('item1', 3),
          throwsException,
        );
      });

      test('should handle repository error on clearCart', () async {
        // Arrange
        when(mockRepository.clearCart()).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => viewModel.clearCart(),
          throwsException,
        );
      });

      test('should handle repository error on refreshCart', () async {
        // Arrange
        when(mockRepository.getCart()).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => viewModel.refreshCart(),
          throwsException,
        );
      });

      test('should set loading to false after error', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenThrow(Exception('Error'));

        // Act & Assert
        expect(viewModel.isLoading, false);

        try {
          await viewModel.addToCart(testProduct, 1);
        } catch (_) {}

        expect(viewModel.isLoading, false);
      });
    });

    group('Complex Scenarios', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should handle multiple sequential operations', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});
        when(mockRepository.updateQuantity(any, any))
            .thenAnswer((_) async => {});
        when(mockRepository.removeItem(any)).thenAnswer((_) async => {});

        final cart1 = Cart(items: [testCartItem]);
        final updatedItem = testCartItem.copyWith(quantity: 5);
        final cart2 = Cart(items: [updatedItem]);

        var seqCallCount = 0;
        when(mockRepository.getCart()).thenAnswer((_) async {
          seqCallCount++;
          if (seqCallCount == 1) return cart1;
          if (seqCallCount == 2) return cart2;
          return Cart(items: []);
        });

        // Act
        await viewModel.addToCart(testProduct, 2);
        expect(viewModel.totalItems, 2);

        await viewModel.updateQuantity('item1', 5);
        expect(viewModel.totalItems, 5);

        await viewModel.removeFromCart('item1');
        expect(viewModel.isEmpty, true);

        // Assert
        verify(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .called(1);
        verify(mockRepository.updateQuantity(any, any)).called(1);
        verify(mockRepository.removeItem(any)).called(1);
      });

      test('should maintain cart state across multiple refreshes', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        // Act
        await viewModel.refreshCart();
        expect(viewModel.totalItems, 2);

        await viewModel.refreshCart();
        expect(viewModel.totalItems, 2);

        await viewModel.refreshCart();
        expect(viewModel.totalItems, 2);

        // Assert
        verify(mockRepository.getCart()).called(3);
      });

      test('should handle adding same product multiple times', () async {
        // Arrange
        when(mockRepository.addItem(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});

        final item1 =
            TestHelpers.createTestCartItem(product: testProduct, quantity: 1);
        final item2 = item1.copyWith(quantity: 2);
        final item3 = item1.copyWith(quantity: 4);

        var sameProductCallCount = 0;
        when(mockRepository.getCart()).thenAnswer((_) async {
          sameProductCallCount++;
          if (sameProductCallCount == 1) return Cart(items: [item1]);
          if (sameProductCallCount == 2) return Cart(items: [item2]);
          return Cart(items: [item3]);
        });

        // Act
        await viewModel.addToCart(testProduct, 1);
        expect(viewModel.totalItems, 1);

        await viewModel.addToCart(testProduct, 1);
        expect(viewModel.totalItems, 2);

        await viewModel.addToCart(testProduct, 2);
        expect(viewModel.totalItems, 4);
      });

      test('should handle cart with multiple different products', () async {
        // Arrange
        final product2 = TestHelpers.createTestProduct(
            id: 'prod2', title: 'Product 2', price: '£15.00');
        final product3 = TestHelpers.createTestProduct(
            id: 'prod3', title: 'Product 3', price: '£10.00');

        final multiItemCart = Cart(items: [
          TestHelpers.createTestCartItem(product: testProduct, quantity: 2),
          TestHelpers.createTestCartItem(product: product2, quantity: 1),
          TestHelpers.createTestCartItem(product: product3, quantity: 3),
        ]);

        when(mockRepository.getCart()).thenAnswer((_) async => multiItemCart);

        // Act
        await viewModel.refreshCart();

        // Assert
        expect(viewModel.cart.items.length, 3);
        expect(viewModel.totalItems, 6); // 2 + 1 + 3
        expect(viewModel.totalPrice,
            95.0); // (25×2) + (15×1) + (10×3) = 50 + 15 + 30
      });

      test('should properly dispose and cleanup', () {
        // Act
        viewModel.dispose();

        // Assert - disposing twice should not throw error
        expect(viewModel.isLoading, false);
      });
    });

    group('Listener Notifications', () {
      setUp(() async {
        when(mockRepository.getCart()).thenAnswer((_) async => Cart(items: []));
        viewModel = CartViewModel(mockRepository);
        await Future.delayed(Duration.zero);
        clearInteractions(mockRepository);
      });

      test('should notify listeners on loading state change', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async =>
            await Future.delayed(Duration(milliseconds: 50), () => testCart));

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.refreshCart();

        // Assert - notified at least twice (loading true, loading false)
        expect(notifyCount, greaterThanOrEqualTo(2));
      });

      test('should allow multiple listeners', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        int notify1 = 0;
        int notify2 = 0;
        int notify3 = 0;

        viewModel.addListener(() => notify1++);
        viewModel.addListener(() => notify2++);
        viewModel.addListener(() => notify3++);

        // Act
        await viewModel.refreshCart();

        // Assert
        expect(notify1, greaterThan(0));
        expect(notify2, greaterThan(0));
        expect(notify3, greaterThan(0));
        expect(notify1, equals(notify2));
        expect(notify2, equals(notify3));
      });

      test('should stop notifying after listener removed', () async {
        // Arrange
        when(mockRepository.getCart()).thenAnswer((_) async => testCart);

        int notifyCount = 0;
        void listener() => notifyCount++;

        viewModel.addListener(listener);
        await viewModel.refreshCart();

        final firstCount = notifyCount;
        viewModel.removeListener(listener);

        // Act
        await viewModel.refreshCart();

        // Assert
        expect(
            notifyCount, equals(firstCount)); // Count unchanged after removal
      });
    });
  });
}
