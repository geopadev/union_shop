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
  final List<Collection> _collections = [
    Collection(
      id: 'clothing',
      name: 'Clothing',
      description: 'Explore our range of clothing items',
      imageUrl: 'assets/images/collections/clothing.jpg',
      productIds: ['1', '2'],
    ),
    Collection(
      id: 'merchandise',
      name: 'Merchandise',
      description: 'University merchandise and accessories',
      imageUrl: 'assets/images/collections/merchandise.jpg',
      productIds: ['2', '3'],
    ),
    Collection(
      id: 'halloween',
      name: 'Halloween 🎃',
      description: 'Spooky season essentials',
      imageUrl: 'assets/images/collections/halloween.jpg',
      productIds: ['1', '3'],
    ),
    Collection(
      id: 'signature-essential',
      name: 'Signature & Essential Range',
      description: 'Our signature collection',
      imageUrl: 'assets/images/collections/signature.jpg',
      productIds: ['1', '2', '3'],
    ),
    Collection(
      id: 'portsmouth',
      name: 'Portsmouth City Collection',
      description: 'Celebrate Portsmouth with our city collection',
      imageUrl: 'assets/images/collections/portsmouth.jpg',
      productIds: ['1', '2', '4'],
    ),
    Collection(
      id: 'pride',
      name: 'Pride Collection 🏳️‍🌈',
      description: 'Show your pride with our rainbow collection',
      imageUrl: 'assets/images/collections/pride.jpg',
      productIds: ['1', '3', '4'],
    ),
    Collection(
      id: 'graduation',
      name: 'Graduation 🎓',
      description: 'Graduation essentials and memorabilia',
      imageUrl: 'assets/images/collections/graduation.jpg',
      productIds: ['2', '3', '4'],
    ),
    Collection(
      id: 'sale',
      name: 'SALE',
      description: 'Amazing deals and discounts',
      imageUrl: 'assets/images/collections/sale.jpg',
      productIds: ['1', '2', '3', '4'],
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
