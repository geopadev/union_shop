import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Home Page Tests', () {
    testWidgets('should display home page with basic elements', (tester) async {
      // Create app with zero-latency repositories for deterministic tests
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Check that basic UI elements are present
      expect(find.text('PLACEHOLDER HEADER TEXT'), findsOneWidget);
      expect(find.byKey(const Key('hero_carousel')), findsOneWidget);
    });

    testWidgets('should display carousel with navigation dots', (tester) async {
      // Create app with zero-latency repositories for deterministic tests
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Check that carousel is displayed
      expect(find.byKey(const Key('hero_carousel')), findsOneWidget);

      // Check that first slide content is visible
      expect(find.text('Explore Portsmouth City Collection'), findsOneWidget);
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
    });

    testWidgets('should display collection sections', (tester) async {
      // Create app with zero-latency repositories for deterministic tests
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Check that collection headings are displayed
      expect(find.text('Signature & Essential Range'), findsOneWidget);
      expect(find.text('Portsmouth City Collection'), findsOneWidget);
      expect(find.text('Pride Collection 🏳️‍🌈'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      // Create app with zero-latency repositories for deterministic tests
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      // Create app with zero-latency repositories for deterministic tests
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Scroll to footer
      await tester.scrollUntilVisible(
        find.byKey(const Key('footer_main')),
        50,
        scrollable: find.byType(Scrollable).first,
      );

      // Check that footer sections are present
      expect(find.byKey(const Key('footer_shop')), findsOneWidget);
      expect(find.byKey(const Key('footer_help')), findsOneWidget);
      expect(find.byKey(const Key('footer_about')), findsOneWidget);
      expect(find.byKey(const Key('footer_social')), findsOneWidget);

      // Check for section headings
      expect(find.text('SHOP'), findsOneWidget);
      expect(find.text('HELP'), findsOneWidget);
      expect(find.text('ABOUT'), findsOneWidget);
      expect(find.text('FOLLOW US'), findsOneWidget);
    });
  });
}
