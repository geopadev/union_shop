import 'package:union_shop/models/product.dart';

/// Repository interface for product data access
/// Implementations should provide configurable latency for testing
abstract class ProductRepository {
  /// Fetch all products
  Future<List<Product>> fetchAll();

  /// Fetch a specific product by ID
  Future<Product?> fetchById(String id);

  /// Search products by query string (searches title and description)
  /// Returns list of products matching the query
  Future<List<Product>> search(String query);
}
