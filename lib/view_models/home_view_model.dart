import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Home screen
/// Manages product list and loading state for the homepage
class HomeViewModel extends BaseViewModel {
  List<Map<String, String>> _products = [];

  /// Unmodifiable list of products to display on homepage
  List<Map<String, String>> get products => List.unmodifiable(_products);

  HomeViewModel() {
    _loadProducts();
  }

  /// Load products data
  /// This is currently using hardcoded data but will be connected
  /// to a repository in future commits
  Future<void> _loadProducts() async {
    await runWithLoading(() async {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _products = [
        {
          'title': 'Placeholder Product 1',
          'price': '£10.00',
          'imageUrl':
              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
        },
        {
          'title': 'Placeholder Product 2',
          'price': '£15.00',
          'imageUrl':
              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
        },
        {
          'title': 'Placeholder Product 3',
          'price': '£20.00',
          'imageUrl':
              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
        },
        {
          'title': 'Placeholder Product 4',
          'price': '£25.00',
          'imageUrl':
              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
        },
      ];
    });
  }

  /// Refresh products list
  Future<void> refreshProducts() async {
    await _loadProducts();
  }
}
