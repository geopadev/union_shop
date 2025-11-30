import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';

/// Abstract repository interface for shopping cart data access
/// Implementations can be in-memory, network-based, or local storage-backed
abstract class CartRepository {
  /// Get the current cart
  Future<Cart> getCart();

  /// Add an item to the cart
  /// If the product already exists, updates the quantity
  Future<void> addItem(Product product, int quantity,
      {Map<String, String>? selectedOptions});

  /// Remove an item from the cart by cart item ID
  Future<void> removeItem(String cartItemId);

  /// Update the quantity of an existing cart item
  Future<void> updateQuantity(String cartItemId, int quantity);

  /// Clear all items from the cart
  Future<void> clearCart();
}
