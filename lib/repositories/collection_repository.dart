import 'package:union_shop/models/collection.dart';

/// Abstract repository interface for collection data access
/// Implementations can be in-memory, network-based, or database-backed
abstract class CollectionRepository {
  /// Fetch all collections
  /// Returns a list of all available collections
  Future<List<Collection>> fetchAll();

  /// Fetch a single collection by ID
  /// Returns the collection if found, null otherwise
  Future<Collection?> fetchById(String id);

  /// Fetch collections that are featured/promoted
  /// Returns a list of featured collections
  Future<List<Collection>> fetchFeatured();
}
