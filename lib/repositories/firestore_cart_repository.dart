import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/cart_repository.dart';

/// Firestore implementation of CartRepository
/// Saves cart data to Firestore per user
class FirestoreCartRepository implements CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId;

  FirestoreCartRepository({this.userId});

  /// Get cart from Firestore for current user
  @override
  Future<Cart> getCart() async {
    if (userId == null) {
      return Cart(items: []);
    }

    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        return Cart(items: []);
      }

      final data = doc.data();
      final cartData = data?['cart'] as List<dynamic>? ?? [];

      final items = cartData.map((item) {
        return CartItem(
          id: item['id'] as String,
          product: Product(
            id: item['product']['id'] as String,
            title: item['product']['title'] as String,
            price: item['product']['price'] as String,
            imageUrl: item['product']['imageUrl'] as String,
            description: item['product']['description'] as String,
          ),
          quantity: item['quantity'] as int,
          selectedOptions: Map<String, String>.from(
            item['selectedOptions'] as Map? ?? {},
          ),
        );
      }).toList();

      return Cart(items: items);
    } catch (e) {
      print('Error loading cart from Firestore: $e');
      return Cart(items: []);
    }
  }

  /// Add item to cart and save to Firestore
  @override
  Future<void> addItem(Product product, int quantity, {Map<String, String>? selectedOptions}) async {
    final cart = await getCart();
    final items = List<CartItem>.from(cart.items);

    // Check if item with same options already exists
    final existingIndex = items.indexWhere((i) =>
        i.product.id == product.id &&
        _areMapsEqual(i.selectedOptions ?? {}, selectedOptions ?? {}));

    if (existingIndex != -1) {
      // Update quantity
      items[existingIndex] = CartItem(
        id: items[existingIndex].id,
        product: items[existingIndex].product,
        quantity: items[existingIndex].quantity + quantity,
        selectedOptions: items[existingIndex].selectedOptions,
      );
    } else {
      final item = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        selectedOptions: selectedOptions,
      );
      items.add(item);
    }

    await _saveCart(items);
  }

  /// Remove item from cart and save to Firestore
  @override
  Future<void> removeItem(String itemId) async {
    final cart = await getCart();
    final items = cart.items.where((item) => item.id != itemId).toList();
    await _saveCart(items);
  }

  /// Update item quantity and save to Firestore
  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    final cart = await getCart();
    final items = List<CartItem>.from(cart.items);

    if (quantity <= 0) {
      items.removeWhere((item) => item.id == itemId);
    } else {
      final index = items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        items[index] = CartItem(
          id: items[index].id,
          product: items[index].product,
          quantity: quantity,
          selectedOptions: items[index].selectedOptions,
        );
      }
    }

    await _saveCart(items);
  }

  /// Clear cart and remove from Firestore
  @override
  Future<void> clearCart() async {
    await _saveCart([]);
  }

  /// Save cart to Firestore
  Future<void> _saveCart(List<CartItem> items) async {
    if (userId == null) return;

    try {
      final cartData = items
          .map((item) => {
                'id': item.id,
                'product': {
                  'id': item.product.id,
                  'title': item.product.title,
                  'price': item.product.price,
                  'imageUrl': item.product.imageUrl,
                  'description': item.product.description,
                },
                'quantity': item.quantity,
                'selectedOptions': item.selectedOptions,
              })
          .toList();

      await _firestore.collection('users').doc(userId).set(
        {'cart': cartData},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error saving cart to Firestore: $e');
    }
  }

  /// Helper to compare two maps
  bool _areMapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }
}
