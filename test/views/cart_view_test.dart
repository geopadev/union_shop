import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/views/cart_view.dart';

import '../helpers/mock_annotations.mocks.dart';

void main() {
  group('CartPage View Tests', () {
    late MockCartViewModel mockCartViewModel;
    late MockAuthService mockAuthService;

    setUp(() {
      mockCartViewModel = MockCartViewModel();
      mockAuthService = MockAuthService();

      // Default mock behaviors
      when(mockAuthService.currentUser).thenReturn(null);
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<CartViewModel>.value(
                value: mockCartViewModel),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: const CartPage(),
        ),
      );
    }

    group('Empty Cart State', () {
      testWidgets('should display empty cart message when cart is empty',
          (tester) async {
        // Arrange
        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(true);
        when(mockCartViewModel.totalItems).thenReturn(0);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Your cart is empty'), findsOneWidget);
        expect(find.text('Add some products to get started!'), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      });

      testWidgets('should display "Continue Shopping" button in empty cart',
          (tester) async {
        // Arrange
        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(true);
        when(mockCartViewModel.totalItems).thenReturn(0);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('CONTINUE SHOPPING'), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('should display loading indicator when cart is loading',
          (tester) async {
        // Arrange
        when(mockCartViewModel.isLoading).thenReturn(true);
        when(mockCartViewModel.isEmpty).thenReturn(false);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Cart with Items', () {
      testWidgets('should display cart items when cart has products',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(2);
        when(mockCartViewModel.formattedTotal).thenReturn('£20.00');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Shopping Cart'), findsOneWidget);
        expect(find.text('2 item(s) in cart'), findsOneWidget);
        expect(find.text('Test Product'), findsOneWidget);
      });

      testWidgets('should display cart totals correctly', (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 3,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(3);
        when(mockCartViewModel.formattedTotal).thenReturn('£30.00');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Subtotal:'), findsOneWidget);
        expect(find.text('£30.00'), findsOneWidget);
      });

      testWidgets('should display "Proceed to Checkout" button',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 1,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(1);
        when(mockCartViewModel.formattedTotal).thenReturn('£10.00');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('PROCEED TO CHECKOUT'), findsOneWidget);
      });
    });

    group('Cart Item Interactions', () {
      testWidgets('should display quantity controls for cart items',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(2);
        when(mockCartViewModel.formattedTotal).thenReturn('£20.00');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - find quantity display
        expect(find.text('2'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.remove), findsOneWidget);
      });

      testWidgets('should call updateQuantity when increment button tapped',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(2);
        when(mockCartViewModel.formattedTotal).thenReturn('£20.00');

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();

        // Assert
        verify(mockCartViewModel.updateQuantity('item-1', 3)).called(1);
      });

      testWidgets('should call updateQuantity when decrement button tapped',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 2,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(2);
        when(mockCartViewModel.formattedTotal).thenReturn('£20.00');

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pump();

        // Assert
        verify(mockCartViewModel.updateQuantity('item-1', 1)).called(1);
      });

      testWidgets('should display remove button for each cart item',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 1,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(1);
        when(mockCartViewModel.formattedTotal).thenReturn('£10.00');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Remove'), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      });

      testWidgets('should call removeFromCart when remove button tapped',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 1,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(1);
        when(mockCartViewModel.formattedTotal).thenReturn('£10.00');

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Remove'));
        await tester.pump();

        // Assert
        verify(mockCartViewModel.removeFromCart('item-1')).called(1);
      });
    });

    group('Checkout Button', () {
      testWidgets('should show snackbar when checkout button tapped',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 1,
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(1);
        when(mockCartViewModel.formattedTotal).thenReturn('£10.00');

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('PROCEED TO CHECKOUT'));
        await tester.pump(); // Start animation
        await tester.pump(
            const Duration(milliseconds: 750)); // Advance snackbar animation

        // Assert
        expect(
            find.text('Checkout functionality coming soon!'), findsOneWidget);
      });
    });

    group('Cart Item Options', () {
      testWidgets('should display selected options for cart items',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );
        final cartItem = CartItem(
          id: 'item-1',
          product: product,
          quantity: 1,
          selectedOptions: {'size': 'Large', 'color': 'Blue'},
        );
        final cart = Cart(items: [cartItem]);

        when(mockCartViewModel.isLoading).thenReturn(false);
        when(mockCartViewModel.isEmpty).thenReturn(false);
        when(mockCartViewModel.cart).thenReturn(cart);
        when(mockCartViewModel.totalItems).thenReturn(1);
        when(mockCartViewModel.formattedTotal).thenReturn('£10.00');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Size: Large'), findsOneWidget);
        expect(find.text('Color: Blue'), findsOneWidget);
      });
    });
  });
}
