import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/repositories/firestore_cart_repository.dart'; // Add this import
import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Shopping Cart
/// Manages cart state and operations
class CartViewModel extends BaseViewModel {
  CartRepository _repository;
  Cart _cart = Cart(items: []);

  /// Current cart
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
    refreshCart();
  }

  /// Update the repository and reload cart
  /// This is called when auth state changes
  Future<void> updateRepository(CartRepository newRepository) async {
    print('🔄 CartViewModel: Switching repository');

    // Get userId from repository if it's FirestoreCartRepository
    String? oldUserId;
    String? newUserId;

    if (_repository is FirestoreCartRepository) {
      oldUserId = (_repository as FirestoreCartRepository).userId;
    }

    if (newRepository is FirestoreCartRepository) {
      newUserId = newRepository.userId;
    }

    print('🔄 Old repository userId: ${oldUserId ?? "guest"}');
    print('🔄 New repository userId: ${newUserId ?? "guest"}');

    _repository = newRepository;

    // Force reload cart from new repository
    await refreshCart();

    print(
        '✅ CartViewModel: Repository switched, cart reloaded (${_cart.totalItems} items)');
  }

  /// Add product to cart
  Future<void> addToCart(
    Product product,
    int quantity, {
    Map<String, String>? selectedOptions,
  }) async {
    await runWithLoading(() async {
      print('➕ Adding to cart: ${product.title} x$quantity');
      await _repository.addItem(product, quantity,
          selectedOptions: selectedOptions);
      await refreshCart();
      print('✅ Cart updated: ${_cart.totalItems} items');
    });
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    await runWithLoading(() async {
      print('🗑️ Removing item from cart: $itemId');
      await _repository.removeItem(itemId);
      await refreshCart();
      print('✅ Cart updated: ${_cart.totalItems} items');
    });
  }

  /// Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    await runWithLoading(() async {
      print('🔢 Updating quantity: $itemId → $quantity');
      await _repository.updateQuantity(itemId, quantity);
      await refreshCart();
      print('✅ Cart updated: ${_cart.totalItems} items');
    });
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    await runWithLoading(() async {
      print('🧹 Clearing cart');
      await _repository.clearCart();
      await refreshCart();
      print('✅ Cart cleared');
    });
  }

  /// Refresh cart from repository
  Future<void> refreshCart() async {
    print('🔄 Refreshing cart from repository...');
    await runWithLoading(() async {
      _cart = await _repository.getCart();
      print('✅ Cart refreshed: ${_cart.totalItems} items');
    });
  }
}
