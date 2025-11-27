import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Product detail screen
/// Manages individual product state and loading
class ProductViewModel extends BaseViewModel {
  final ProductRepository _repository;
  Product? _product;

  /// Current product being displayed
  Product? get product => _product;

  ProductViewModel(this._repository, {String? productId}) {
    if (productId != null) {
      _loadProduct(productId);
    }
  }

  /// Load product data from repository by ID
  Future<void> _loadProduct(String productId) async {
    await runWithLoading(() async {
      _product = await _repository.fetchById(productId);
    });
  }

  /// Load a specific product by ID
  Future<void> loadProductById(String productId) async {
    await _loadProduct(productId);
  }

  /// Refresh product data
  Future<void> refreshProduct() async {
    if (_product != null) {
      await _loadProduct(_product!.id);
    }
  }
}
