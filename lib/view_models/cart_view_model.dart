import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for shopping cart
/// Manages cart state and operations following MVVM pattern
class CartViewModel extends BaseViewModel {
  final CartRepository _repository;
  Cart _cart = Cart.empty();

  /// Current cart state
  Cart get cart => _cart;

  /// Total number of items in cart
  int get totalItems => _cart.totalItems;

  /// Total price of all items in cart
  double get totalPrice => _cart.totalPrice;

  /// Formatted total price string
  String get formattedTotal => _cart.formattedTotal;

  /// Check if cart is empty
  bool get isEmpty => _cart.isEmpty;

  CartViewModel(this._repository) {
    _loadCart();
  }

  /// Load cart data from repository
  Future<void> _loadCart() async {
    await runWithLoading(() async {
      _cart = await _repository.getCart();
    });
  }

  /// Add a product to the cart
  /// If product already exists with same options, quantity is incremented
  Future<void> addToCart(
    Product product,
    int quantity, {
    Map<String, String>? selectedOptions,
  }) async {
    await runWithLoading(() async {
      await _repository.addItem(product, quantity,
          selectedOptions: selectedOptions);
      _cart = await _repository.getCart();
    });
  }

  /// Remove an item from the cart by cart item ID
  Future<void> removeFromCart(String cartItemId) async {
    await runWithLoading(() async {
      await _repository.removeItem(cartItemId);
      _cart = await _repository.getCart();
    });
  }

  /// Update the quantity of an existing cart item
  /// If quantity is 0 or negative, the item is removed
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await runWithLoading(() async {
      await _repository.updateQuantity(cartItemId, quantity);
      _cart = await _repository.getCart();
    });
  }

  /// Clear all items from the cart
  Future<void> clearCart() async {
    await runWithLoading(() async {
      await _repository.clearCart();
      _cart = await _repository.getCart();
    });
  }

  /// Refresh cart data from repository
  Future<void> refreshCart() async {
    await _loadCart();
  }
}
