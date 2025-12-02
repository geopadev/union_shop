import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';
import 'package:union_shop/views/product_view.dart';

import '../helpers/mock_annotations.mocks.dart';

void main() {
  group('ProductPage View Integration Tests', () {
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

    testWidgets('should display error message when product not found',
        (tester) async {
      // Arrange
      when(mockProductViewModel.isLoading).thenReturn(false);
      when(mockProductViewModel.product).thenReturn(null);

      // Act
      await tester.pumpWidget(createTestWidget(productId: 'nonexistent'));

      // Assert
      expect(find.text('Product not found'), findsOneWidget);
    });

    testWidgets('should display product details when product is loaded',
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

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
    });

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

    testWidgets('should display sale badge when product is on sale',
        (tester) async {
      // Arrange
      final product = Product(
        id: 'test-1',
        title: 'Sale Product',
        price: '£15.00',
        originalPrice: '£25.00',
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
      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgets('should display product image', (tester) async {
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
      expect(find.byType(Image), findsWidgets);
    });
  });
}
