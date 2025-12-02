import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Home screen
/// Manages product list and loading state for the homepage
class HomeViewModel extends BaseViewModel {
  final ProductRepository _repository;
  List<Product> _products = [];

  /// Unmodifiable list of products to display on homepage
  List<Product> get products => List.unmodifiable(_products);

  HomeViewModel(this._repository) {
    // Don't await - let initialization happen asynchronously
    // Errors will be silently handled to prevent constructor from throwing
    _loadProducts().catchError((_) {
      // Error during initial load is ignored
      // UI should handle empty product list gracefully
    });
  }

  get error => null;

  /// Load products data from repository
  Future<void> _loadProducts() async {
    await runWithLoading(() async {
      _products = await _repository.fetchAll();
    });
  }

  /// Refresh products list
  Future<void> refreshProducts() async {
    await _loadProducts();
  }
}
