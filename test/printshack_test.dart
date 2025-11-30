import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_cart_repository.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Print Shack Tests', () {
    testWidgets('should navigate to print shack about page', (tester) async {
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

      // Navigate to print shack about page via URL
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
        cartRepo: cartRepo,
      ));
      await tester.pumpAndSettle();

      // Verify we're on about page by checking for key
      expect(find.byKey(const Key('printshack_about_page')), findsOneWidget);
      expect(find.text('The Print Shack'), findsOneWidget);
      expect(find.text('START PERSONALIZING'), findsOneWidget);
    });

    testWidgets('should navigate from about to personalization page',
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

      // Verify personalization page loads
      expect(find.byKey(const Key('personalization_page')), findsOneWidget);
      expect(find.text('Personalize Your Item'), findsOneWidget);
    });

    testWidgets('should display all form fields on personalization page',
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

      // Check for text input field
      expect(
          find.byKey(const Key('personalization_text_input')), findsOneWidget);

      // Check for form labels
      expect(find.text('Your Text (max 20 characters)'), findsOneWidget);
      expect(find.text('Font'), findsOneWidget);
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('Text Color'), findsOneWidget);

      // Check for add to cart button
      expect(find.byKey(const Key('add_personalized_to_cart')), findsOneWidget);
    });

    testWidgets('should update preview when text is entered', (tester) async {
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

      // Initially preview should show default message
      expect(find.text('Enter your text to see preview'), findsOneWidget);

      // Enter text
      await tester.enterText(
        find.byKey(const Key('personalization_text_input')),
        'TEST TEXT',
      );
      await tester.pumpAndSettle();

      // Preview should update to show entered text
      expect(find.textContaining('Your Text: "TEST TEXT"'), findsOneWidget);
    });

    testWidgets('should update preview and price when size is selected',
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

      // Initially price should show "Select a size"
      expect(find.text('Select a size'), findsOneWidget);

      // Enter text first
      await tester.enterText(
        find.byKey(const Key('personalization_text_input')),
        'My Text',
      );
      await tester.pumpAndSettle();

      // Find and tap the Size dropdown
      await tester.tap(find.text('Select Size').first);
      await tester.pumpAndSettle();

      // Select Medium size
      await tester.tap(find.text('M').last);
      await tester.pumpAndSettle();

      // Price should now show £7.00 (Medium price)
      expect(find.text('£7.00'), findsOneWidget);
    });

    testWidgets('should show validation error when adding incomplete form',
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

      // Try to add to cart without filling form
      await tester.tap(find.byKey(const Key('add_personalized_to_cart')));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(
        find.text('Please fill in all fields before adding to cart'),
        findsOneWidget,
      );
    });

    testWidgets('should add personalized item to cart when form is complete',
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

      // Fill in the form
      // 1. Enter text
      await tester.enterText(
        find.byKey(const Key('personalization_text_input')),
        'Custom',
      );
      await tester.pumpAndSettle();

      // 2. Select font
      await tester.tap(find.text('Select Font').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arial').last);
      await tester.pumpAndSettle();

      // 3. Select size
      await tester.tap(find.text('Select Size').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('L').last);
      await tester.pumpAndSettle();

      // 4. Select color
      await tester.tap(find.text('Select Text Color').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Red').last);
      await tester.pumpAndSettle();

      // Add to cart
      await tester.tap(find.byKey(const Key('add_personalized_to_cart')));
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Personalized item added to cart!'), findsOneWidget);

      // Cart badge should show 1 item
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should display correct pricing for all sizes', (tester) async {
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

      // Enter text first
      await tester.enterText(
        find.byKey(const Key('personalization_text_input')),
        'Test',
      );
      await tester.pumpAndSettle();

      // Test Small (S) - £5.00
      await tester.tap(find.text('Select Size').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('S').last);
      await tester.pumpAndSettle();
      expect(find.text('£5.00'), findsOneWidget);

      // Test Medium (M) - £7.00
      await tester.tap(find.text('S').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('M').last);
      await tester.pumpAndSettle();
      expect(find.text('£7.00'), findsOneWidget);

      // Test Large (L) - £9.00
      await tester.tap(find.text('M').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('L').last);
      await tester.pumpAndSettle();
      expect(find.text('£9.00'), findsOneWidget);

      // Test Extra Large (XL) - £11.00
      await tester.tap(find.text('L').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('XL').last);
      await tester.pumpAndSettle();
      expect(find.text('£11.00'), findsOneWidget);
    });
  });
}
