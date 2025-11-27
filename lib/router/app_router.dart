import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/about_view.dart';
import 'package:union_shop/views/collections_overview_view.dart';
import 'package:union_shop/views/collections_view.dart';
import 'package:union_shop/views/home_view.dart';
import 'package:union_shop/views/product_view.dart';

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
    ],
  );
}
