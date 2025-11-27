import 'package:union_shop/models/collection.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/collection_repository.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Collections screen
/// Manages collection and product data for collection pages
class CollectionViewModel extends BaseViewModel {
  final CollectionRepository _collectionRepository;
  final ProductRepository _productRepository;
  List<Collection> _collections = [];
  List<Product> _allProducts = [];

  /// Unmodifiable list of collections
  List<Collection> get collections => List.unmodifiable(_collections);

  CollectionViewModel(this._collectionRepository, this._productRepository) {
    _loadData();
  }

  /// Load collections and products data from repositories
  Future<void> _loadData() async {
    await runWithLoading(() async {
      _collections = await _collectionRepository.fetchAll();
      _allProducts = await _productRepository.fetchAll();
    });
  }

  /// Get a specific collection by ID
  Collection? getCollectionById(String id) {
    try {
      return _collections.firstWhere((collection) => collection.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get products for a specific collection
  List<Product> getProductsForCollection(String collectionId) {
    final collection = getCollectionById(collectionId);
    if (collection == null) return [];

    return _allProducts
        .where((product) => collection.productIds.contains(product.id))
        .toList();
  }

  /// Refresh collections and products data
  Future<void> refreshData() async {
    await _loadData();
  }
}
