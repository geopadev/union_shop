import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';

import '../../helpers/mock_annotations.mocks.dart';

void main() {
  group('SharedHeader Widget Tests', () {
    late MockCartViewModel mockCartViewModel;
    late MockAuthService mockAuthService;

    setUp(() {
      mockCartViewModel = MockCartViewModel();
      mockAuthService = MockAuthService();

      // Default mock behaviors
      when(mockCartViewModel.totalItems).thenReturn(0);
      when(mockAuthService.currentUser).thenReturn(null);
    });

    Widget createTestWidget({
      VoidCallback? onLogoTap,
      VoidCallback? onCartTap,
    }) {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<CartViewModel>.value(
                value: mockCartViewModel),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: Scaffold(
            endDrawer: const Drawer(),
            body: SharedHeader(
              onLogoTap: onLogoTap,
              onCartTap: onCartTap,
            ),
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render header with all main components',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byKey(const Key('header_banner')), findsOneWidget);
        expect(find.byKey(const Key('app_logo')), findsOneWidget);
        expect(find.byKey(const Key('header_search')), findsOneWidget);
        expect(find.byKey(const Key('header_account')), findsOneWidget);
        expect(find.byKey(const Key('header_cart')), findsOneWidget);
      });

      testWidgets('should display banner text', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(
          find.text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!'),
          findsOneWidget,
        );
      });

      testWidgets('should render logo image', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final logoFinder = find.byKey(const Key('app_logo'));
        expect(logoFinder, findsOneWidget);

        final image = tester.widget<Image>(logoFinder);
        expect(image.image, isA<NetworkImage>());
      });
    });

    group('Icon Buttons', () {
      testWidgets('should render search icon button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final searchButton = find.byKey(const Key('header_search'));
        expect(searchButton, findsOneWidget);

        final iconButton = tester.widget<IconButton>(searchButton);
        expect(iconButton.icon, isA<Icon>());
      });

      testWidgets('should render account icon button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final accountButton = find.byKey(const Key('header_account'));
        expect(accountButton, findsOneWidget);

        final iconButton = tester.widget<IconButton>(accountButton);
        expect(iconButton.icon, isA<Icon>());
      });

      testWidgets('should render cart icon button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final cartButton = find.byKey(const Key('header_cart'));
        expect(cartButton, findsOneWidget);

        final iconButton = tester.widget<IconButton>(cartButton);
        expect(iconButton.icon, isA<Icon>());
      });
    });

    group('Cart Badge', () {
      testWidgets('should not display cart badge when cart is empty',
          (tester) async {
        // Arrange
        when(mockCartViewModel.totalItems).thenReturn(0);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('0'), findsNothing);
      });

      testWidgets(
          'should display cart badge with item count when cart has items',
          (tester) async {
        // Arrange
        when(mockCartViewModel.totalItems).thenReturn(3);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('should display "9+" when cart has more than 9 items',
          (tester) async {
        // Arrange
        when(mockCartViewModel.totalItems).thenReturn(15);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('9+'), findsOneWidget);
        expect(find.text('15'), findsNothing);
      });

      testWidgets('should display exact count for 9 items', (tester) async {
        // Arrange
        when(mockCartViewModel.totalItems).thenReturn(9);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('9'), findsOneWidget);
        expect(find.text('9+'), findsNothing);
      });

      testWidgets('should display "9+" for 10 items', (tester) async {
        // Arrange
        when(mockCartViewModel.totalItems).thenReturn(10);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('9+'), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('should call onLogoTap when logo is tapped', (tester) async {
        // Arrange
        bool logoTapped = false;
        void onLogoTap() => logoTapped = true;

        await tester.pumpWidget(createTestWidget(onLogoTap: onLogoTap));

        // Act
        await tester.tap(find.byKey(const Key('logoTap')));
        await tester.pump();

        // Assert
        expect(logoTapped, true);
      });

      testWidgets('should call onCartTap when cart icon is tapped',
          (tester) async {
        // Arrange
        bool cartTapped = false;
        void onCartTap() => cartTapped = true;

        await tester.pumpWidget(createTestWidget(onCartTap: onCartTap));

        // Act
        await tester.tap(find.byKey(const Key('header_cart')));
        await tester.pump();

        // Assert
        expect(cartTapped, true);
      });
    });

    group('Tooltips', () {
      testWidgets('should have tooltip for search button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final searchButton =
            tester.widget<IconButton>(find.byKey(const Key('header_search')));
        expect(searchButton.tooltip, 'Search');
      });

      testWidgets('should have tooltip for account button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final accountButton =
            tester.widget<IconButton>(find.byKey(const Key('header_account')));
        expect(accountButton.tooltip, 'Account');
      });

      testWidgets('should have tooltip for cart button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final cartButton =
            tester.widget<IconButton>(find.byKey(const Key('header_cart')));
        expect(cartButton.tooltip, 'Shopping cart');
      });
    });

    group('Accessibility', () {
      testWidgets('should have semantic label for logo', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final semantics = tester.getSemantics(find.byKey(const Key('logoTap')));
        expect(semantics.label,
            contains('University of Portsmouth Students Union logo'));
      });

      testWidgets('should have proper semantics for logo tap area',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert - verify logo tap area exists
        expect(find.byKey(const Key('logoTap')), findsOneWidget);
      });
    });

    group('Responsive Behavior', () {
      testWidgets('should show menu button on narrow screens', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(600, 800));

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byKey(const Key('header_menu')), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should not show menu button on wide screens',
          (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(1024, 768));

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byKey(const Key('header_menu')), findsNothing);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
