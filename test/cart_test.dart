import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_cart_repository.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Shopping Cart Tests', () {
    testWidgets('should display empty cart state', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Navigate to cart page
      await tester.tap(find.byKey(const Key('header_cart')));
      await tester.pumpAndSettle();

      // Verify empty cart state
      expect(find.byKey(const Key('cart_page')), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('CONTINUE SHOPPING'), findsOneWidget);
    });

    testWidgets('should add item to cart from product page', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Verify SnackBar confirmation
      expect(find.text('Added 1 item(s) to cart'), findsOneWidget);
    });

    testWidgets('should display cart badge with item count', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Initially, cart badge should not be visible
      expect(find.text('1'), findsNothing);

      // Navigate to product page
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Cart badge should now show "1"
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should navigate to cart page and view items', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Navigate to product page and add item
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Navigate to cart page
      await tester.tap(find.byKey(const Key('header_cart')));
      await tester.pumpAndSettle();

      // Verify cart page displays item
      expect(find.byKey(const Key('cart_page')), findsOneWidget);
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('1 item(s) in cart'), findsOneWidget);
      expect(find.byKey(const Key('cart_item_0')), findsOneWidget);
      expect(find.text('Placeholder Product Name'), findsOneWidget);
    });

    testWidgets('should update item quantity in cart', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byKey(const Key('header_cart')));
      await tester.pumpAndSettle();

      // Find the + button within the cart item
      final addButton = find.descendant(
        of: find.byKey(const Key('cart_item_0')),
        matching: find.byIcon(Icons.add),
      );

      // Tap + button to increase quantity
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify quantity increased
      expect(find.text('2 item(s) in cart'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Cart badge
    });

    testWidgets('should remove item from cart', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byKey(const Key('header_cart')));
      await tester.pumpAndSettle();

      // Tap remove button
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Verify empty cart state
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('CONTINUE SHOPPING'), findsOneWidget);
    });

    testWidgets('should display cart totals correctly', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byKey(const Key('header_cart')));
      await tester.pumpAndSettle();

      // Verify totals
      expect(find.text('Subtotal:'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('PROCEED TO CHECKOUT'), findsOneWidget);
    });

    testWidgets('should show correct badge for multiple items',
        (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      final cartRepo = InMemoryCartRepository(latency: Duration.zero);

      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();

      // Increase quantity to 3
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Add to cart
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Verify cart badge shows "3"
      expect(find.text('3'), findsOneWidget);
    });
  });
}
