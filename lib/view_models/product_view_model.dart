import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Product detail screen
/// Manages individual product state and loading
class ProductViewModel extends BaseViewModel {
  Map<String, String>? _product;

  /// Current product being displayed
  Map<String, String>? get product => _product;

  ProductViewModel() {
    _loadProduct();
  }

  /// Load product data
  /// This is currently using hardcoded data but will be connected
  /// to a repository in future commits
  Future<void> _loadProduct() async {
    await runWithLoading(() async {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _product = {
        'title': 'Placeholder Product Name',
        'price': '£15.00',
        'imageUrl':
            'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
        'description':
            'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.',
      };
    });
  }

  /// Refresh product data
  Future<void> refreshProduct() async {
    await _loadProduct();
  }
}
