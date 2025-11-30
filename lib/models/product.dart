import 'package:union_shop/models/product_option.dart';

/// Product model representing a product in the shop
class Product {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String description;
  final List<ProductOption>? options; // Optional list of product options

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.options, // Optional parameter
  });

  /// Helper to check if product has options
  bool get hasOptions => options != null && options!.isNotEmpty;

  /// Helper to check if product has a specific option type
  bool hasOptionType(ProductOptionType type) {
    if (!hasOptions) return false;
    return options!.any((option) => option.type == type);
  }

  /// Get option by type
  ProductOption? getOptionByType(ProductOptionType type) {
    if (!hasOptions) return null;
    try {
      return options!.firstWhere((option) => option.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      price: map['price'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      options: (map['options'] as List<dynamic>?)
          .map((option) => ProductOption.fromMap(option))
          .toList(),
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
      'options': options?.map((option) => option.toMap()).toList(),
    };
  }
}
