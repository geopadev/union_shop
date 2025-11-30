import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/view_models/product_view_model.dart';
import 'package:union_shop/widgets/product/product_options_selector.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class ProductPage extends StatefulWidget {
  final String? collectionId;
  final String? productId;

  const ProductPage({
    super.key,
    this.collectionId,
    this.productId,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  Map<String, String> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    // Load product if productId is provided
    if (widget.productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductViewModel>().loadProductById(widget.productId!);
      });
    }
  }

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _onOptionsChanged(Map<String, String> options) {
    setState(() {
      _selectedOptions = options;
    });
  }

  bool _validateOptions(Product product) {
    if (!product.hasOptions) return true;

    // Check if all required options are selected
    for (var option in product.options!) {
      if (option.required && !_selectedOptions.containsKey(option.id)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _addToCart(BuildContext context, Product product) async {
    // Validate options selection
    if (!_validateOptions(product)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select all required options'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartViewModel = context.read<CartViewModel>();
    await cartViewModel.addToCart(
      product,
      _quantity,
      selectedOptions: _selectedOptions,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $_quantity item(s) to cart'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF4d2963),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MobileNavigationDrawer(),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          final product = viewModel.product;

          // Show loading indicator while fetching product
          if (viewModel.isLoading) {
            return Column(
              children: [
                SharedHeader(
                  onLogoTap: () => navigateToHome(context),
                  onSearchTap: placeholderCallbackForButtons,
                  onAccountTap: placeholderCallbackForButtons,
                  onCartTap: () => context.go('/cart'),
                  onMenuTap: placeholderCallbackForButtons,
                ),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4d2963),
                    ),
                  ),
                ),
              ],
            );
          }

          // Show error if product not found
          if (product == null) {
            return Column(
              children: [
                SharedHeader(
                  onLogoTap: () => navigateToHome(context),
                  onSearchTap: placeholderCallbackForButtons,
                  onAccountTap: placeholderCallbackForButtons,
                  onCartTap: () => context.go('/cart'),
                  onMenuTap: placeholderCallbackForButtons,
                ),
                const Expanded(
                  child: Center(
                    child: Text('Product not found'),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                SharedHeader(
                  onLogoTap: () => navigateToHome(context),
                  onSearchTap: placeholderCallbackForButtons,
                  onAccountTap: placeholderCallbackForButtons,
                  onCartTap: () => context.go('/cart'),
                  onMenuTap: placeholderCallbackForButtons,
                ),

                // Product details
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb Navigation
                      if (widget.collectionId != null) ...[
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.go('/'),
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4d2963),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(
                              ' > ',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () => context.go(
                                  '/collections/${widget.collectionId}'),
                              child: Text(
                                widget.collectionId!
                                    .replaceAll('-', ' ')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4d2963),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(
                              ' > ',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Product image
                      Semantics(
                        image: true,
                        label: 'Product image for ${product.title}',
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image_not_supported,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Add image:',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          product.imageUrl,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Product name
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Product price
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Product Options Selector (if product has options)
                      if (product.hasOptions) ...[
                        ProductOptionsSelector(
                          options: product.options!,
                          onOptionsChanged: _onOptionsChanged,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Quantity Selector
                      Row(
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _decrementQuantity,
                                  iconSize: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _incrementQuantity,
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('add_to_cart_button'),
                          onPressed: () => _addToCart(context, product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Product description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer
                const SharedFooter(),
              ],
            );
          },
        ),
      ),
    );
  }
}
