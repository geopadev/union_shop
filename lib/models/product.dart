/// Product model representing a product in the shop
class Product {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  /// Create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      price: map['price'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
    );
  }

  /// Convert Product to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
