import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Product Page Tests', () {
    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      // Create app with zero-latency repository for deterministic tests
      final repo = InMemoryProductRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(productRepo: repo));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();

      // Check that basic UI elements are present
      expect(find.text('PLACEHOLDER HEADER TEXT'), findsOneWidget);
      expect(find.text('Placeholder Product Name'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      // Create app with zero-latency repository for deterministic tests
      final repo = InMemoryProductRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(productRepo: repo));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('Placeholder Product 1'));
      await tester.pumpAndSettle();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      // Create app with zero-latency repository for deterministic tests
      final repo = InMemoryProductRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(productRepo: repo));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('Placeholder Product 1'));
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
    });
  });
}
