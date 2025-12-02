import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/product_option.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';
import 'package:union_shop/views/product_view.dart';

import '../helpers/mock_annotations.mocks.dart';

void main() {
  group('ProductPage View Tests', () {
    late MockProductViewModel mockProductViewModel;
    late MockCartViewModel mockCartViewModel;
    late MockAuthService mockAuthService;

    setUp(() {
      mockProductViewModel = MockProductViewModel();
      mockCartViewModel = MockCartViewModel();
      mockAuthService = MockAuthService();

      // Default mock behaviors
      when(mockAuthService.currentUser).thenReturn(null);
      when(mockCartViewModel.totalItems).thenReturn(0);
    });

    Widget createTestWidget({String? productId}) {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductViewModel>.value(
                value: mockProductViewModel),
            ChangeNotifierProvider<CartViewModel>.value(
                value: mockCartViewModel),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: ProductPage(productId: productId),
        ),
      );
    }

    group('Loading State', () {
      testWidgets('should display loading indicator when product is loading',
          (tester) async {
        // Arrange
        when(mockProductViewModel.isLoading).thenReturn(true);
        when(mockProductViewModel.product).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Error State', () {
      testWidgets('should display error message when product not found',
          (tester) async {
        // Arrange
        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'invalid'));

        // Assert
        expect(find.text('Product not found'), findsOneWidget);
      });
    });

    group('Product Display', () {
      testWidgets('should display product details when product is loaded',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Assert
        expect(find.text('Test Product'), findsOneWidget);
        expect(find.text('£25.00'), findsOneWidget);
      });

      testWidgets(
          'should display sale badge and pricing when product is on sale',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Sale Product',
          price: '£15.00',
          originalPrice: '£25.00',
          savings: 'Save £10.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
          isOnSale: true,
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Assert
        expect(find.text('SALE'), findsOneWidget);
        expect(find.text('£15.00'), findsOneWidget);
        expect(find.text('£25.00'), findsOneWidget); // Original price
        expect(find.text('Save £10.00'), findsOneWidget);
      });
    });

    group('Quantity Controls', () {
      testWidgets('should display quantity selector', (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Assert
        expect(find.text('Quantity:'), findsOneWidget);
        expect(find.text('1'), findsOneWidget); // Initial quantity
        expect(find.byIcon(Icons.add), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.remove), findsAtLeastNWidgets(1));
      });

      testWidgets('should increment quantity when add button tapped',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Find the add button in the quantity selector (not the cart badge)
        final addButtons = find.byIcon(Icons.add);
        expect(addButtons, findsAtLeastNWidgets(1));

        // Tap the last add button (the one in the quantity selector)
        await tester.tap(addButtons.last);
        await tester.pump();

        // Assert - quantity should increment to 2
        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('should decrement quantity when remove button tapped',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // First increment to 2
        final addButtons = find.byIcon(Icons.add);
        await tester.tap(addButtons.last);
        await tester.pump();
        expect(find.text('2'), findsOneWidget);

        // Then decrement back to 1
        final removeButtons = find.byIcon(Icons.remove);
        await tester.tap(removeButtons.last);
        await tester.pump();

        // Assert - quantity should be back to 1
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('should not decrement quantity below 1', (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Try to decrement below 1
        final removeButtons = find.byIcon(Icons.remove);
        await tester.tap(removeButtons.last);
        await tester.pump();

        // Assert - quantity should still be 1
        expect(find.text('1'), findsOneWidget);
      });
    });

    group('Add to Cart', () {
      testWidgets('should display "Add to Cart" button', (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Assert
        expect(find.byKey(const Key('add_to_cart_button')), findsOneWidget);
        expect(find.text('ADD TO CART'), findsOneWidget);
      });

      testWidgets(
          'should add product to cart when button tapped without options',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);
        when(mockCartViewModel.addToCart(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));
        await tester.tap(find.byKey(const Key('add_to_cart_button')));
        await tester.pump();

        // Assert
        verify(mockCartViewModel.addToCart(product, 1, selectedOptions: {}))
            .called(1);
      });

      testWidgets('should show success snackbar after adding to cart',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);
        when(mockCartViewModel.addToCart(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));
        await tester.tap(find.byKey(const Key('add_to_cart_button')));
        await tester.pump(); // Start animation
        await tester.pump(
            const Duration(milliseconds: 750)); // Advance snackbar animation

        // Assert
        expect(find.textContaining('Added 1 item(s) to cart'), findsOneWidget);
      });
    });

    group('Product Options', () {
      testWidgets(
          'should display product options selector when product has options',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
          options: [
            ProductOption(
              id: 'size',
              name: 'Size',
              required: true,
              values: ['Small', 'Medium', 'Large'],
            ),
          ],
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Assert
        expect(find.text('Size'), findsOneWidget);
        expect(find.text('Small'), findsOneWidget);
        expect(find.text('Medium'), findsOneWidget);
        expect(find.text('Large'), findsOneWidget);
      });

      testWidgets(
          'should show error when adding to cart without selecting required options',
          (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
          options: [
            ProductOption(
              id: 'size',
              name: 'Size',
              required: true,
              values: ['Small', 'Medium', 'Large'],
            ),
          ],
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));
        await tester.tap(find.byKey(const Key('add_to_cart_button')));
        await tester.pump(); // Start animation
        await tester.pump(
            const Duration(milliseconds: 750)); // Advance snackbar animation

        // Assert
        expect(find.text('Please select all required options'), findsOneWidget);
        verifyNever(mockCartViewModel.addToCart(any, any,
            selectedOptions: anyNamed('selectedOptions')));
      });

      testWidgets('should select product option when tapped', (tester) async {
        // Arrange
        final product = Product(
          id: 'test-1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'assets/test.jpg',
          description: 'Test description',
          options: [
            ProductOption(
              id: 'size',
              name: 'Size',
              required: true,
              values: ['Small', 'Medium', 'Large'],
            ),
          ],
        );

        when(mockProductViewModel.isLoading).thenReturn(false);
        when(mockProductViewModel.product).thenReturn(product);
        when(mockCartViewModel.addToCart(any, any,
                selectedOptions: anyNamed('selectedOptions')))
            .thenAnswer((_) async => {});

        // Act
        await tester.pumpWidget(createTestWidget(productId: 'test-1'));

        // Select Medium size
        await tester.tap(find.text('Medium'));
        await tester.pump();

        // Now add to cart
        await tester.tap(find.byKey(const Key('add_to_cart_button')));
        await tester.pump();

        // Assert - should successfully add with selected option
        verify(mockCartViewModel.addToCart(product, 1,
            selectedOptions: {'size': 'Medium'})).called(1);
      });
    });
  });
}
