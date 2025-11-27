import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/repositories/in_memory_product_repository.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/view_models/home_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';
import 'package:union_shop/views/home_view.dart';
import 'package:union_shop/views/product_view.dart';

void main() {
  runApp(createApp());
}

/// Factory function to create the app with optional dependency injection
/// This allows tests to inject mock repositories with zero latency
Widget createApp({
  ProductRepository? productRepo,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  // Use provided repository or create default with 500ms latency
  final repository = productRepo ?? InMemoryProductRepository();

  return MultiProvider(
    providers: [
      // Repository provider
      Provider<ProductRepository>.value(value: repository),

      // ViewModel providers
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(repository),
      ),
      ChangeNotifierProvider<ProductViewModel>(
        create: (_) => ProductViewModel(repository),
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
      },
    );
  }
}
