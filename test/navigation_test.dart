import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Navigation Menu Tests', () {
    testWidgets('should display all main navigation items', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Check that main navigation items are present
      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('SHOP'), findsOneWidget);
      expect(find.text('The Print Shack'), findsOneWidget);
      expect(find.text('SALE!'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('should navigate to About page when About is tapped',
        (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Tap About navigation item
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Verify we're on About page
      expect(find.byKey(const Key('about_page')), findsOneWidget);
    });

    testWidgets('should navigate to home when HOME is tapped', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Navigate to About page first
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Tap HOME navigation item
      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();

      // Verify we're back on home page (check for carousel)
      expect(find.byKey(const Key('hero_carousel')), findsOneWidget);
    });
  });

  group('Mobile Navigation Drawer Tests', () {
    testWidgets('should open mobile drawer when menu button is tapped',
        (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Tap menu button
      await tester.tap(find.byKey(const Key('header_menu')));
      await tester.pumpAndSettle();

      // Verify drawer is open
      expect(find.byKey(const Key('mobile_nav_drawer')), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);
    });

    testWidgets('should close drawer after navigation', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byKey(const Key('header_menu')));
      await tester.pumpAndSettle();

      // Tap About in drawer (need to find the ListTile with About text)
      await tester.tap(find.text('About').last);
      await tester.pumpAndSettle();

      // Verify drawer is closed and we're on About page
      expect(find.byKey(const Key('mobile_nav_drawer')), findsNothing);
      expect(find.byKey(const Key('about_page')), findsOneWidget);
    });
  });
}
