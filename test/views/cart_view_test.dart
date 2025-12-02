import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/views/cart_view.dart';

import '../helpers/mock_annotations.mocks.dart';

void main() {
  group('CartPage View Integration Tests', () {
    late MockCartViewModel mockCartViewModel;
    late MockAuthService mockAuthService;

    setUp(() {
      mockCartViewModel = MockCartViewModel();
      mockAuthService = MockAuthService();

      // Default mock behaviors
      when(mockAuthService.currentUser).thenReturn(null);
      when(mockCartViewModel.totalItems).thenReturn(0);
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

    testWidgets('should display empty cart message when cart is empty',
        (tester) async {
      // Arrange
      when(mockCartViewModel.isLoading).thenReturn(false);
      when(mockCartViewModel.isEmpty).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add some products to get started!'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('CONTINUE SHOPPING'), findsOneWidget);
    });

    testWidgets('should display cart page structure', (tester) async {
      // Arrange
      when(mockCartViewModel.isLoading).thenReturn(false);
      when(mockCartViewModel.isEmpty).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - verify page structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byKey(const Key('cart_page')), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display "Shopping Cart" title when cart has items',
        (tester) async {
      // Arrange
      final emptyCart = Cart(items: []);
      when(mockCartViewModel.isLoading).thenReturn(false);
      when(mockCartViewModel.isEmpty).thenReturn(false);
      when(mockCartViewModel.cart).thenReturn(emptyCart);
      when(mockCartViewModel.totalItems).thenReturn(0);
      when(mockCartViewModel.formattedTotal).thenReturn('£0.00');

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('0 item(s) in cart'), findsOneWidget);
    });

    testWidgets('should display cart totals section when cart has items',
        (tester) async {
      // Arrange
      final emptyCart = Cart(items: []);
      when(mockCartViewModel.isLoading).thenReturn(false);
      when(mockCartViewModel.isEmpty).thenReturn(false);
      when(mockCartViewModel.cart).thenReturn(emptyCart);
      when(mockCartViewModel.totalItems).thenReturn(0);
      when(mockCartViewModel.formattedTotal).thenReturn('£0.00');

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Subtotal:'), findsOneWidget);
      expect(find.text('£0.00'), findsOneWidget);
      expect(find.text('PROCEED TO CHECKOUT'), findsOneWidget);
    });

    testWidgets('should show snackbar when checkout button tapped',
        (tester) async {
      // Arrange
      final emptyCart = Cart(items: []);
      when(mockCartViewModel.isLoading).thenReturn(false);
      when(mockCartViewModel.isEmpty).thenReturn(false);
      when(mockCartViewModel.cart).thenReturn(emptyCart);
      when(mockCartViewModel.totalItems).thenReturn(0);
      when(mockCartViewModel.formattedTotal).thenReturn('£0.00');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.ensureVisible(find.text('PROCEED TO CHECKOUT'));
      await tester.tap(find.text('PROCEED TO CHECKOUT'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      // Assert
      expect(find.text('Checkout functionality coming soon!'), findsOneWidget);
    });
  });
}
