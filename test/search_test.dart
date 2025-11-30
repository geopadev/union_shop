import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_cart_repository.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Search Functionality Tests', () {
    testWidgets('should display search page with search bar', (tester) async {
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

      // Navigate to search page via header icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search page elements
      expect(find.byKey(const Key('search_page')), findsOneWidget);
      expect(find.text('Search Products'), findsOneWidget);
      expect(find.byKey(const Key('search_input')), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('should show initial state message', (tester) async {
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Should show initial message
      expect(
        find.text('Enter a search term to find products'),
        findsOneWidget,
      );
    });

    testWidgets('should perform search and display results', (tester) async {
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(
        find.byKey(const Key('search_input')),
        'Product',
      );
      await tester.pumpAndSettle();

      // Tap search button
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Should display results
      expect(find.text('4 results for "Product"'), findsOneWidget);
      expect(find.byKey(const Key('search_result_0')), findsOneWidget);
    });

    testWidgets('should show no results message for non-matching query',
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter non-matching search query
      await tester.enterText(
        find.byKey(const Key('search_input')),
        'NonexistentProduct',
      );
      await tester.pumpAndSettle();

      // Tap search button
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Should show no results message
      expect(
        find.text('No results found for "NonexistentProduct"'),
        findsOneWidget,
      );
      expect(
        find.text('Try different keywords or browse our collections'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should search using enter key', (tester) async {
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query and submit with enter key
      await tester.enterText(
        find.byKey(const Key('search_input')),
        'Placeholder',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Should display results
      expect(find.textContaining('results for "Placeholder"'), findsOneWidget);
    });

    testWidgets('should display search results in responsive grid',
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Perform search
      await tester.enterText(
        find.byKey(const Key('search_input')),
        'Product',
      );
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Should display multiple result cards
      expect(find.byKey(const Key('search_result_0')), findsOneWidget);
      expect(find.byKey(const Key('search_result_1')), findsOneWidget);
      expect(find.byKey(const Key('search_result_2')), findsOneWidget);
      expect(find.byKey(const Key('search_result_3')), findsOneWidget);
    });

    testWidgets('should search by product description', (tester) async {
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Search by description keyword
      await tester.enterText(
        find.byKey(const Key('search_input')),
        'description',
      );
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Should find products by description
      expect(find.textContaining('results for "description"'), findsOneWidget);
      expect(find.byKey(const Key('search_result_0')), findsOneWidget);
    });

    testWidgets('should be case-insensitive', (tester) async {
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

      // Navigate to search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Search with different case
      await tester.enterText(
        find.byKey(const Key('search_input')),
        'PLACEHOLDER',
      );
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Should find products regardless of case
      expect(find.textContaining('results for "PLACEHOLDER"'), findsOneWidget);
      expect(find.byKey(const Key('search_result_0')), findsOneWidget);
    });
  });
}
