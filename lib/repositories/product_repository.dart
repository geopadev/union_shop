import 'package:union_shop/models/product.dart';

/// Abstract repository interface for product data access
/// Implementations can be in-memory, network-based, or database-backed
abstract class ProductRepository {
  /// Fetch all products
  /// Returns a list of all available products
  Future<List<Product>> fetchAll();

  /// Fetch a single product by ID
  /// Returns the product if found, null otherwise
  Future<Product?> fetchById(String id);

  /// Search products by query string
  /// Returns products matching the search criteria
  Future<List<Product>> search(String query);
}
