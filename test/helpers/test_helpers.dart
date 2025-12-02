import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/collection.dart';

/// Test helper utilities and mock data for tests
class TestHelpers {
  /// Create a test product with default values
  static Product createTestProduct({
    String id = 'test-product-1',
    String title = 'Test Product',
    String price = '£20.00',
    String imageUrl = 'assets/images/products/test.jpg',
    String description = 'Test product description',
    List<String>? collectionIds,
    bool isOnSale = false,
    String originalPrice = '',
  }) {
    return Product(
      id: id,
      title: title,
      price: price,
      imageUrl: imageUrl,
      description: description,
      collectionIds: collectionIds ?? ['test-collection'],
      isOnSale: isOnSale,
      originalPrice: originalPrice,
    );
  }

  /// Create a test cart item
  static CartItem createTestCartItem({
    String? id,
    Product? product,
    int quantity = 1,
    Map<String, String>? selectedOptions,
  }) {
    return CartItem(
      id: id ?? 'test-cart-item-1',
      product: product ?? createTestProduct(),
      quantity: quantity,
      selectedOptions: selectedOptions,
    );
  }

  /// Create a test cart with items
  static Cart createTestCart({
    List<CartItem>? items,
  }) {
    return Cart(
      items: items ?? [createTestCartItem()],
    );
  }

  /// Create a test collection
  static Collection createTestCollection({
    String id = 'test-collection',
    String name = 'Test Collection',
    String description = 'Test collection description',
    String imageUrl = 'assets/images/collections/test.jpg',
    List<String>? productIds,
  }) {
    return Collection(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      productIds: productIds ?? ['test-product-1', 'test-product-2'],
    );
  }

  /// Parse price string to double (e.g., "£20.00" -> 20.0)
  static double parsePrice(String price) {
    return double.parse(price.replaceAll('£', '').replaceAll(',', ''));
  }

  /// Format double to price string (e.g., 20.0 -> "£20.00")
  static String formatPrice(double price) {
    return '£${price.toStringAsFixed(2)}';
  }
}
