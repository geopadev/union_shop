import 'package:union_shop/models/collection.dart';
import 'package:union_shop/repositories/collection_repository.dart';

/// In-memory implementation of CollectionRepository
/// Uses hardcoded data with configurable latency for testing
class InMemoryCollectionRepository implements CollectionRepository {
  final Duration latency;

  /// Create repository with optional artificial latency
  /// Set latency to Duration.zero for deterministic tests
  InMemoryCollectionRepository({
    this.latency = const Duration(milliseconds: 500),
  });

  /// Hardcoded collection data
  static final List<Collection> _collections = [
    Collection(
      id: 'clothing',
      name: 'Clothing',
      description: 'Explore our range of comfortable and stylish clothing',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: ['1', '2', '3'], // Products 1, 2, 3 in Clothing
    ),
    Collection(
      id: 'merchandise',
      name: 'Merchandise',
      description: 'University branded merchandise and accessories',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: [
        '2',
        '4'
      ], // Products 2, 4 in Merchandise (2 is shared with Clothing)
    ),
    Collection(
      id: 'halloween',
      name: 'Halloween 🎃',
      description: 'Spooky season essentials and Halloween specials',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: [
        '1',
        '3',
        '4'
      ], // Products 1, 3, 4 (shared with Clothing and Merchandise)
    ),
    Collection(
      id: 'signature-essential',
      name: 'Signature & Essential Range',
      description: 'Our core collection of everyday essentials',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: [
        '1',
        '2',
        '3',
        '4'
      ], // All products (shared across all collections)
    ),
    Collection(
      id: 'portsmouth',
      name: 'Portsmouth City Collection',
      description: 'Celebrate Portsmouth with our exclusive city collection',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: ['1', '2', '4'], // Products 1, 2, 4 (shared)
    ),
    Collection(
      id: 'pride',
      name: 'Pride Collection 🏳️‍🌈',
      description: 'Show your pride with our inclusive collection',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: [
        '1',
        '3'
      ], // Products 1, 3 (shared with Clothing, Halloween, etc.)
    ),
    Collection(
      id: 'graduation',
      name: 'Graduation 🎓',
      description: 'Celebrate your graduation with our special collection',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: ['2', '3', '4'], // Products 2, 3, 4 (shared)
    ),
    Collection(
      id: 'sale',
      name: 'SALE!',
      description: 'Amazing deals on selected items',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productIds: ['1', '2'], // Products 1, 2 on sale
    ),
  ];

  @override
  Future<List<Collection>> fetchAll() async {
    // Simulate network delay
    await Future.delayed(latency);
    return List.unmodifiable(_collections);
  }

  @override
  Future<Collection?> fetchById(String id) async {
    // Simulate network delay
    await Future.delayed(latency);
    try {
      return _collections.firstWhere((collection) => collection.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Collection>> fetchFeatured() async {
    // Simulate network delay
    await Future.delayed(latency);
    // Return first 4 collections as featured
    return _collections.take(4).toList();
  }
}
