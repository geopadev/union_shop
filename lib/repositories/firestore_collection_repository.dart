import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/repositories/collection_repository.dart';

/// Firestore implementation of CollectionRepository
/// Fetches collections from Firestore 'collections' collection
class FirestoreCollectionRepository implements CollectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Collection>> fetchAll() async {
    try {
      final snapshot = await _firestore.collection('collections').get();

      return snapshot.docs.map((doc) {
        return _collectionFromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching collections from Firestore: $e');
      return [];
    }
  }

  @override
  Future<Collection?> fetchById(String id) async {
    try {
      final doc = await _firestore.collection('collections').doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return _collectionFromFirestore(doc);
    } catch (e) {
      print('Error fetching collection $id from Firestore: $e');
      return null;
    }
  }

  @override
  Future<List<Collection>> fetchFeatured() async {
    // Return featured collections (you can customize this logic)
    try {
      final allCollections = await fetchAll();

      // Return first 3 collections as featured
      // You could add a 'featured' field in Firestore to filter by
      return allCollections.take(3).toList();
    } catch (e) {
      print('Error fetching featured collections: $e');
      return [];
    }
  }

  /// Convert Firestore document to Collection model
  Collection _collectionFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Collection(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
      productIds: List<String>.from(data['productIds'] as List),
    );
  }
}
