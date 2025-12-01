import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/product_option.dart';
import 'package:union_shop/repositories/product_repository.dart';

/// Firestore implementation of ProductRepository
/// Fetches products from Firestore 'products' collection
class FirestoreProductRepository implements ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Product>> fetchAll() async {
    try {
      final snapshot = await _firestore.collection('products').get();

      return snapshot.docs.map((doc) {
        return _productFromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching products from Firestore: $e');
      return [];
    }
  }

  @override
  Future<Product?> fetchById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return _productFromFirestore(doc);
    } catch (e) {
      print('Error fetching product $id from Firestore: $e');
      return null;
    }
  }

  @override
  Future<List<Product>> search(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      // Fetch all products and filter client-side
      final allProducts = await fetchAll();

      final lowerQuery = query.toLowerCase();
      return allProducts.where((product) {
        return product.title.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  /// Convert Firestore document to Product model
  Product _productFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse options if they exist
    List<ProductOption>? options;
    if (data['options'] != null) {
      final optionsData = data['options'] as List<dynamic>;
      options = optionsData.map((optionData) {
        return ProductOption(
          id: optionData['id'] as String,
          name: optionData['name'] as String,
          type: _parseOptionType(optionData['type'] as String),
          values: List<String>.from(optionData['values'] as List),
          required: optionData['required'] as bool? ?? false,
        );
      }).toList();
    }

    return Product(
      id: data['id'] as String,
      title: data['title'] as String,
      price: data['price'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
      collectionIds: data['collectionIds'] != null
          ? List<String>.from(data['collectionIds'] as List)
          : null,
      options: options,
      isOnSale: data['isOnSale'] as bool? ?? false,
      originalPrice: data['originalPrice'] as String?,
    );
  }

  /// Parse option type string to enum
  ProductOptionType _parseOptionType(String type) {
    switch (type.toLowerCase()) {
      case 'size':
        return ProductOptionType.size;
      case 'color':
        return ProductOptionType.color;
      case 'material':
        return ProductOptionType.material;
      default:
        return ProductOptionType.size;
    }
  }
}
