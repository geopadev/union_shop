import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/repositories/in_memory_cart_repository.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';
import 'package:union_shop/repositories/collection_repository.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/router/app_router.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/view_models/home_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';

void main() {
  runApp(createApp());
}

/// Factory function to create the app with optional dependency injection
/// This allows tests to inject mock repositories with zero latency
Widget createApp({
  ProductRepository? productRepo,
  CollectionRepository? collectionRepo,
  CartRepository? cartRepo,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  // Use provided repositories or create defaults with 500ms latency
  final productRepository = productRepo ?? InMemoryProductRepository();
  final collectionRepository = collectionRepo ?? InMemoryCollectionRepository();
  final cartRepository = cartRepo ?? InMemoryCartRepository();

  return MultiProvider(
    providers: [
      // Repository providers
      Provider<ProductRepository>.value(value: productRepository),
      Provider<CollectionRepository>.value(value: collectionRepository),
      Provider<CartRepository>.value(value: cartRepository),

      // ViewModel providers
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(productRepository),
      ),
      ChangeNotifierProvider<ProductViewModel>(
        create: (_) => ProductViewModel(productRepository),
      ),
      ChangeNotifierProvider<CollectionViewModel>(
        create: (_) =>
            CollectionViewModel(collectionRepository, productRepository),
      ),
      ChangeNotifierProvider<CartViewModel>(
        create: (_) => CartViewModel(cartRepository),
      ),
    ],
    child: UnionShopApp(navigatorKey: navigatorKey),
  );
}

class UnionShopApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const UnionShopApp({super.key, this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    // Create router configuration
    final router = createRouter(navigatorKey: navigatorKey);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
    );
  }
}
