/// Collection model representing a group of related products
class Collection {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> productIds;

  const Collection({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.productIds,
  });

  /// Create a Collection from a Map
  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      productIds: List<String>.from(map['productIds'] as List),
    );
  }

  /// Convert Collection to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'productIds': productIds,
    };
  }
}
