import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/firebase_options.dart';
import 'package:union_shop/services/firebase_test.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/repositories/firestore_cart_repository.dart';
import 'package:union_shop/repositories/collection_repository.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/repositories/firestore_product_repository.dart';
import 'package:union_shop/repositories/firestore_collection_repository.dart';
import 'package:union_shop/router/app_router.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/view_models/home_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';
import 'package:union_shop/view_models/search_view_model.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Test Firebase connection (remove this in production)
  await testFirebaseConnection();

  runApp(createApp());
}

/// Factory function to create the app
/// Uses Firestore repositories exclusively
Widget createApp({
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  // Always use Firestore repositories
  final productRepository = FirestoreProductRepository();
  final collectionRepository = FirestoreCollectionRepository();
  final authenticationService = AuthService();

  return MultiProvider(
    providers: [
      // Repository providers
      Provider<ProductRepository>.value(value: productRepository),
      Provider<CollectionRepository>.value(value: collectionRepository),
      Provider<AuthService>.value(value: authenticationService),

      // CartViewModel with dynamic repository switching
      ChangeNotifierProxyProvider<AuthService, CartViewModel>(
        create: (context) {
          // Start with guest cart (no userId)
          print('🛒 Creating CartViewModel with guest cart (initial)');
          return CartViewModel(FirestoreCartRepository());
        },
        update: (context, authService, previousCart) {
          final userId = authService.currentUser?.uid;
          print(
              '🔄 Auth state changed. User: ${authService.currentUser?.email ?? "guest"} (${userId ?? "no-id"})');

          // Create new repository based on auth state
          final newRepo = userId != null
              ? FirestoreCartRepository(userId: userId)
              : FirestoreCartRepository();

          print('🔄 New repository created with userId: ${userId ?? "null"}');

          // Update existing CartViewModel with new repository
          if (previousCart != null) {
            print('♻️ Updating existing cart with new repository');
            previousCart.updateRepository(newRepo);
            return previousCart;
          }

          print('✨ Creating new CartViewModel');
          return CartViewModel(newRepo);
        },
      ),

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
      ChangeNotifierProvider<SearchViewModel>(
        create: (_) => SearchViewModel(productRepository),
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
