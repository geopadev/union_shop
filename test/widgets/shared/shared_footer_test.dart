import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

void main() {
  group('SharedFooter Widget Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: Scaffold(
          body: SharedFooter(),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render footer with main key', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byKey(const Key('footer_main')), findsOneWidget);
      });

      testWidgets('should render copyright text', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(
          find.textContaining(
              '© 2024 University of Portsmouth Students\' Union'),
          findsOneWidget,
        );
      });
    });

    group('Shop Section', () {
      testWidgets('should render Shop section heading', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('SHOP'), findsOneWidget);
      });

      testWidgets('should render all shop section links', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Clothing'), findsOneWidget);
        expect(find.text('Merchandise'), findsOneWidget);
        expect(find.text('Portsmouth City Collection'), findsOneWidget);
        expect(find.text('Pride Collection'), findsOneWidget);
        expect(find.text('Graduation'), findsOneWidget);
        expect(find.text('Sale Items'), findsOneWidget);
      });
    });

    group('Help Section', () {
      testWidgets('should render Help section heading', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('HELP'), findsOneWidget);
      });

      testWidgets('should render all help section links', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Contact Us'), findsOneWidget);
        expect(find.text('Delivery Information'), findsOneWidget);
        expect(find.text('Returns Policy'), findsOneWidget);
        expect(find.text('Terms & Conditions'), findsOneWidget);
        expect(find.text('Privacy Policy'), findsOneWidget);
      });
    });

    group('About Section', () {
      testWidgets('should render About section heading', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('ABOUT'), findsOneWidget);
      });

      testWidgets('should render all about section links', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('About Us'), findsOneWidget);
        expect(find.text('Store Location'), findsOneWidget);
        expect(find.text('Opening Hours'), findsOneWidget);
      });
    });

    group('Social Section', () {
      testWidgets('should render FOLLOW US section heading', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('FOLLOW US'), findsOneWidget);
      });

      testWidgets('should render social icons', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - social media is displayed as icons, not text
        expect(find.byKey(const Key('footer_social')), findsOneWidget);
        expect(find.byIcon(Icons.facebook), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt), findsOneWidget); // Instagram
        expect(find.byIcon(Icons.flutter_dash),
            findsOneWidget); // Twitter placeholder
      });
    });

    group('Responsive Layout', () {
      testWidgets('should render desktop layout on wide screens',
          (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(1024, 1200));

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - desktop layout shows sections
        expect(find.byKey(const Key('footer_main')), findsOneWidget);
        expect(find.text('SHOP'), findsOneWidget);
        expect(find.text('HELP'), findsOneWidget);
        expect(find.text('ABOUT'), findsOneWidget);
        expect(find.text('FOLLOW US'), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should render mobile layout on narrow screens',
          (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(600, 1200));

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - mobile layout shows sections
        expect(find.byKey(const Key('footer_main')), findsOneWidget);
        expect(find.text('SHOP'), findsOneWidget);
        expect(find.text('HELP'), findsOneWidget);
        expect(find.text('ABOUT'), findsOneWidget);
        expect(find.text('FOLLOW US'), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Link Structure', () {
      testWidgets('should render correct number of footer sections',
          (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(1024, 1200));

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - 4 main sections
        expect(find.text('SHOP'), findsOneWidget);
        expect(find.text('HELP'), findsOneWidget);
        expect(find.text('ABOUT'), findsOneWidget);
        expect(find.text('FOLLOW US'), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should have accessible link styling', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(1024, 1200));

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - verify all links are rendered as text
        final shopLinks = [
          'Clothing',
          'Merchandise',
          'Portsmouth City Collection',
          'Pride Collection',
          'Graduation',
          'Sale Items'
        ];
        final helpLinks = [
          'Contact Us',
          'Delivery Information',
          'Returns Policy',
          'Terms & Conditions',
          'Privacy Policy'
        ];
        final aboutLinks = ['About Us', 'Store Location', 'Opening Hours'];

        for (final link in [...shopLinks, ...helpLinks, ...aboutLinks]) {
          expect(find.text(link), findsOneWidget);
        }

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
