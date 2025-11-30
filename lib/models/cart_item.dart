import 'package:union_shop/models/product.dart';

/// Model representing an item in the shopping cart
/// Contains product reference, quantity, and optional selections
class CartItem {
  final String id; // Unique identifier for the cart item
  final Product product;
  final int quantity;
  final Map<String, String>?
      selectedOptions; // e.g., {'size': 'M', 'color': 'Red'}

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedOptions,
  });

  /// Calculate total price for this cart item (price * quantity)
  double get totalPrice {
    final priceString = product.price.replaceAll('£', '').trim();
    final price = double.tryParse(priceString) ?? 0.0;
    return price * quantity;
  }

  /// Create a copy of this cart item with updated fields
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    Map<String, String>? selectedOptions,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, product: ${product.title}, quantity: $quantity, options: $selectedOptions)';
  }
}
