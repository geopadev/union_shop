import 'package:union_shop/models/product_option.dart';

/// Product model representing a product in the shop
class Product {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String description;
  final List<ProductOption>? options;
  final bool isOnSale;
  final String? originalPrice;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.options,
    this.isOnSale = false,
    this.originalPrice,
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

  /// Get the display price (sale price if on sale, regular price otherwise)
  String get displayPrice => price;

  /// Get the savings amount if on sale
  String? get savings {
    if (!isOnSale || originalPrice == null) return null;

    // Parse prices (assuming format £XX.XX)
    final original = double.tryParse(originalPrice!.replaceAll('£', ''));
    final current = double.tryParse(price.replaceAll('£', ''));

    if (original == null || current == null) return null;

    final saved = original - current;
    return 'Save £${saved.toStringAsFixed(2)}';
  }
}
