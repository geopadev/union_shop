import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';

void main() {
  group('Carousel Tests', () {
    testWidgets('should display carousel navigation dots', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Check that carousel is present
      expect(find.byKey(const Key('hero_carousel')), findsOneWidget);

      // Check that first slide is displayed
      expect(find.text('Explore Portsmouth City Collection'), findsOneWidget);

      // Check that navigation dots exist (should be 3 dots for 3 slides)
      // Dots are Container widgets with circular shape
      final dotFinder = find.descendant(
        of: find.byKey(const Key('hero_carousel')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle,
        ),
      );
      expect(dotFinder, findsNWidgets(3));
    });

    testWidgets('should navigate to next slide when arrow button is tapped',
        (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Verify first slide is displayed
      expect(find.text('Explore Portsmouth City Collection'), findsOneWidget);

      // Find and tap the next arrow button
      final nextButtonFinder = find.descendant(
        of: find.byKey(const Key('hero_carousel')),
        matching: find.byIcon(Icons.arrow_forward_ios),
      );
      await tester.tap(nextButtonFinder);
      await tester.pumpAndSettle();

      // Verify second slide is displayed
      expect(find.text('Halloween Special 🎃'), findsOneWidget);
    });

    testWidgets('should navigate to previous slide when arrow button is tapped',
        (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // First navigate to second slide
      final nextButtonFinder = find.descendant(
        of: find.byKey(const Key('hero_carousel')),
        matching: find.byIcon(Icons.arrow_forward_ios),
      );
      await tester.tap(nextButtonFinder);
      await tester.pumpAndSettle();

      // Verify we're on second slide
      expect(find.text('Halloween Special 🎃'), findsOneWidget);

      // Tap previous arrow button
      final prevButtonFinder = find.descendant(
        of: find.byKey(const Key('hero_carousel')),
        matching: find.byIcon(Icons.arrow_back_ios),
      );
      await tester.tap(prevButtonFinder);
      await tester.pumpAndSettle();

      // Verify we're back on first slide
      expect(find.text('Explore Portsmouth City Collection'), findsOneWidget);
    });

    testWidgets('should toggle pause/play button', (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Find pause button (should show pause icon initially)
      final pauseButtonFinder = find.descendant(
        of: find.byKey(const Key('hero_carousel')),
        matching: find.byIcon(Icons.pause),
      );
      expect(pauseButtonFinder, findsOneWidget);

      // Tap pause button
      await tester.tap(pauseButtonFinder);
      await tester.pump();

      // Should now show play icon
      final playButtonFinder = find.descendant(
        of: find.byKey(const Key('hero_carousel')),
        matching: find.byIcon(Icons.play_arrow),
      );
      expect(playButtonFinder, findsOneWidget);

      // Tap play button
      await tester.tap(playButtonFinder);
      await tester.pump();

      // Should show pause icon again
      expect(pauseButtonFinder, findsOneWidget);
    });

    testWidgets('should navigate when carousel button is tapped',
        (tester) async {
      final productRepo = InMemoryProductRepository(latency: Duration.zero);
      final collectionRepo =
          InMemoryCollectionRepository(latency: Duration.zero);
      await tester.pumpWidget(createApp(
        productRepo: productRepo,
        collectionRepo: collectionRepo,
      ));
      await tester.pumpAndSettle();

      // Verify first slide button is present
      expect(find.byKey(const Key('browse_collection_button')), findsOneWidget);

      // Tap the carousel button
      await tester.tap(find.text('BROWSE COLLECTION'));
      await tester.pumpAndSettle();

      // Verify navigation occurred (should be on collections page)
      expect(find.byKey(const Key('collections_page')), findsOneWidget);
    });
  });
}
