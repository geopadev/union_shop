import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/product_repository.dart';

/// In-memory implementation of ProductRepository
/// Uses hardcoded data with configurable latency for testing
class InMemoryProductRepository implements ProductRepository {
  final Duration latency;

  /// Create repository with optional artificial latency
  /// Set latency to Duration.zero for deterministic tests
  InMemoryProductRepository({
    this.latency = const Duration(milliseconds: 500),
  });

  /// Hardcoded product data
  final List<Product> _products = [
    Product(
      id: '1',
      title: 'Placeholder Product 1',
      price: '£15.00',
      imageUrl: 'assets/images/products/product_1.jpg',
      description: 'This is a placeholder description for product 1.',
    ),
    Product(
      id: '2',
      title: 'Placeholder Product 2',
      price: '£20.00',
      imageUrl: 'assets/images/products/product_2.jpg',
      description: 'This is a placeholder description for product 2.',
    ),
    Product(
      id: '3',
      title: 'Placeholder Product 3',
      price: '£25.00',
      imageUrl: 'assets/images/products/product_3.jpg',
      description: 'This is a placeholder description for product 3.',
    ),
    Product(
      id: '4',
      title: 'Placeholder Product 4',
      price: '£30.00',
      imageUrl: 'assets/images/products/product_4.jpg',
      description: 'This is a placeholder description for product 4.',
    ),
  ];

  @override
  Future<List<Product>> fetchAll() async {
    // Simulate network delay
    await Future.delayed(latency);
    return List.unmodifiable(_products);
  }

  @override
  Future<Product?> fetchById(String id) async {
    // Simulate network delay
    await Future.delayed(latency);
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> search(String query) async {
    // Simulate network delay
    await Future.delayed(latency);
    final lowercaseQuery = query.toLowerCase();
    return _products
        .where((product) =>
            product.title.toLowerCase().contains(lowercaseQuery) ||
            (product.description.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }
}
