import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/repositories/in_memory_collection_repository.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';
import 'package:union_shop/repositories/collection_repository.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/view_models/home_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';
import 'package:union_shop/views/about_view.dart';
import 'package:union_shop/views/collections_overview_view.dart';
import 'package:union_shop/views/collections_view.dart';
import 'package:union_shop/views/home_view.dart';
import 'package:union_shop/views/product_view.dart';

void main() {
  runApp(createApp());
}

/// Factory function to create the app with optional dependency injection
/// This allows tests to inject mock repositories with zero latency
Widget createApp({
  ProductRepository? productRepo,
  CollectionRepository? collectionRepo,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  // Use provided repositories or create defaults with 500ms latency
  final productRepository = productRepo ?? InMemoryProductRepository();
  final collectionRepository = collectionRepo ?? InMemoryCollectionRepository();

  return MultiProvider(
    providers: [
      // Repository providers
      Provider<ProductRepository>.value(value: productRepository),
      Provider<CollectionRepository>.value(value: collectionRepository),

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
    ],
    child: UnionShopApp(navigatorKey: navigatorKey),
  );
}

class UnionShopApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const UnionShopApp({super.key, this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      initialRoute: '/',
      routes: {
        '/product': (context) => const ProductPage(),
        '/about': (context) => const AboutPage(),
        '/collections': (context) => const CollectionsOverviewPage(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routes with parameters
        if (settings.name != null && settings.name!.startsWith('/shop/')) {
          final collectionId = settings.name!.replaceFirst('/shop/', '');
          return MaterialPageRoute(
            builder: (context) => CollectionsPage(collectionId: collectionId),
          );
        }
        return null;
      },
    );
  }
}
