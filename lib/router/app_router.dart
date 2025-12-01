import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/about_view.dart';
import 'package:union_shop/views/auth/signup_view.dart';
import 'package:union_shop/views/auth/login_view.dart';
import 'package:union_shop/views/cart_view.dart';
import 'package:union_shop/views/collections_overview_view.dart';
import 'package:union_shop/views/collections_view.dart';
import 'package:union_shop/views/home_view.dart';
import 'package:union_shop/views/product_view.dart';
import 'package:union_shop/views/printshack/personalization_view.dart';
import 'package:union_shop/views/printshack/printshack_about_view.dart';
import 'package:union_shop/views/search_view.dart';

/// Creates and returns the GoRouter configuration for the application
/// This handles all routing including deep linking and browser URL updates
GoRouter createRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Home route
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // About route
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),

      // Collections overview route
      GoRoute(
        path: '/collections',
        builder: (context, state) => const CollectionsOverviewPage(),
      ),

      // Individual collection route
      GoRoute(
        path: '/collections/:collectionId',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          return CollectionsPage(collectionId: collectionId);
        },
        routes: [
          // Nested product route within collection
          GoRoute(
            path: 'products/:productId',
            builder: (context, state) {
              final collectionId = state.pathParameters['collectionId']!;
              final productId = state.pathParameters['productId']!;
              return ProductPage(
                collectionId: collectionId,
                productId: productId,
              );
            },
          ),
        ],
      ),

      // Fallback product route (without collection context)
      GoRoute(
        path: '/product',
        builder: (context, state) => const ProductPage(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/printshack/about',
        builder: (context, state) => const PrintShackAboutPage(),
      ),
      GoRoute(
        path: '/printshack/personalisation',
        builder: (context, state) => const PersonalizationPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchPage(initialQuery: query);
        },
      ),
      GoRoute(
        path: '/account/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/account/login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
