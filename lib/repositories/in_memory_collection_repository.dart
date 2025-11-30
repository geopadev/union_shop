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
    const Collection(
      id: 'clothing',
      name: 'Clothing',
      description: 'Explore our range of university branded clothing',
      imageUrl: 'assets/images/collections/clothing.jpg',
      productIds: [
        'classic-hoodie',
        'classic-sweatshirt',
        'polo-shirt',
        'varsity-jacket',
        'pride-tshirt',
      ],
    ),
    const Collection(
      id: 'merchandise',
      name: 'Merchandise',
      description: 'University merchandise and accessories',
      imageUrl: 'assets/images/collections/merchandise.jpg',
      productIds: [
        'water-bottle',
        'tote-bag',
        'notebook',
        'lanyard',
        'pride-pin',
      ],
    ),
    const Collection(
      id: 'halloween',
      name: 'Halloween 🎃',
      description: 'Spooky season essentials and Halloween themed items',
      imageUrl: 'assets/images/collections/halloween.jpg',
      productIds: [
        'halloween-tshirt',
        'halloween-stickers',
        'halloween-tote',
      ],
    ),
    const Collection(
      id: 'signature-essential',
      name: 'Signature & Essential Range',
      description: 'Our signature collection of essential university items',
      imageUrl: 'assets/images/collections/signature.jpg',
      productIds: [
        'classic-hoodie',
        'classic-sweatshirt',
        'water-bottle',
        'tote-bag',
        'notebook',
      ],
    ),
    const Collection(
      id: 'portsmouth',
      name: 'Portsmouth City Collection',
      description: 'Celebrate Portsmouth with our city-themed collection',
      imageUrl: 'assets/images/collections/portsmouth.jpg',
      productIds: [
        'portsmouth-magnet',
        'portsmouth-mug',
        'portsmouth-keyring',
        'portsmouth-postcard-set',
        'varsity-jacket',
      ],
    ),
    const Collection(
      id: 'pride',
      name: 'Pride Collection 🏳️‍🌈',
      description:
          'Show your pride with our rainbow collection supporting LGBTQ+ community',
      imageUrl: 'assets/images/collections/pride.jpg',
      productIds: [
        'pride-flag',
        'pride-pin',
        'rainbow-lanyard',
        'pride-tshirt',
      ],
    ),
    const Collection(
      id: 'graduation',
      name: 'Graduation 🎓',
      description: 'Graduation essentials and celebration memorabilia',
      imageUrl: 'assets/images/collections/graduation.jpg',
      productIds: [
        'graduation-bear',
        'graduation-frame',
        'graduation-card',
      ],
    ),
    const Collection(
      id: 'sale',
      name: 'SALE',
      description: 'Amazing deals and discounts on selected items',
      imageUrl: 'assets/images/collections/sale.jpg',
      productIds: [
        'halloween-tshirt',
        'halloween-stickers',
        'tote-bag',
        'notebook',
        'lanyard',
      ],
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
