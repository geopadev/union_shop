import 'package:union_shop/models/cart_item.dart';

/// Model representing the shopping cart
/// Aggregates cart items and provides convenience getters for totals
class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  /// Empty cart constructor
  Cart.empty() : items = [];

  /// Get total number of items in cart (sum of all quantities)
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get total price of all items in cart
  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get formatted total price string
  String get formattedTotal {
    return '£${totalPrice.toStringAsFixed(2)}';
  }

  /// Create a copy of this cart with updated items
  Cart copyWith({List<CartItem>? items}) {
    return Cart(
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'Cart(items: ${items.length}, totalItems: $totalItems, totalPrice: $formattedTotal)';
  }
}
