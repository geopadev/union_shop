import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/cart_repository.dart';

/// In-memory implementation of CartRepository
/// Simulates cart persistence with configurable latency for realistic async operations
class InMemoryCartRepository implements CartRepository {
  final Duration latency;
  final List<CartItem> _items = [];

  InMemoryCartRepository({this.latency = const Duration(milliseconds: 500)});

  /// Simulate async delay for realistic data fetching
  Future<void> _simulateLatency() async {
    await Future.delayed(latency);
  }

  @override
  Future<Cart> getCart() async {
    await _simulateLatency();
    return Cart(items: List.from(_items));
  }

  @override
  Future<void> addItem(
    Product product,
    int quantity, {
    Map<String, String>? selectedOptions,
  }) async {
    await _simulateLatency();

    // Check if product with same options already exists in cart
    final existingItemIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );

    if (existingItemIndex != -1) {
      // Update quantity of existing item
      final existingItem = _items[existingItemIndex];
      _items[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // Add new item to cart
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        selectedOptions: selectedOptions,
      );
      _items.add(newItem);
    }
  }

  @override
  Future<void> removeItem(String cartItemId) async {
    await _simulateLatency();
    _items.removeWhere((item) => item.id == cartItemId);
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await _simulateLatency();

    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (quantity <= 0) {
        // Remove item if quantity is 0 or negative
        _items.removeAt(index);
      } else {
        // Update quantity
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> clearCart() async {
    await _simulateLatency();
    _items.clear();
  }

  /// Helper method to compare selected options maps
  bool _areOptionsEqual(
    Map<String, String>? options1,
    Map<String, String>? options2,
  ) {
    if (options1 == null && options2 == null) return true;
    if (options1 == null || options2 == null) return false;
    if (options1.length != options2.length) return false;

    for (var key in options1.keys) {
      if (options1[key] != options2[key]) return false;
    }

    return true;
  }
}
