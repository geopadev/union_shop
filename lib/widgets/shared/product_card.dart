import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/product.dart';

/// Shared ProductCard widget used across home, collections, and search views
/// Displays product image, title, price with hover effects and navigation
class ProductCard extends StatefulWidget {
  final Product product;
  final String? collectionId; // Optional: for collection context in navigation

  const ProductCard({
    super.key,
    required this.product,
    this.collectionId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Determine navigation URL based on whether we have collection context
    final String navigationUrl = _getNavigationUrl();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => context.go(navigationUrl),
        child: Semantics(
          button: true,
          label:
              'Product: ${widget.product.title}, Price: ${widget.product.price}',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(_isHovering ? 1.03 : 1.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: _isHovering
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with SALE badge
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Semantics(
                          image: true,
                          label: 'Image of ${widget.product.title}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Add image:\n${widget.product.imageUrl}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
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
                      // SALE badge
                      if (widget.product.isOnSale)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'SALE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Product title
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Product price (with strikethrough if on sale)
                  if (widget.product.isOnSale &&
                      widget.product.originalPrice != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Original price with strikethrough
                        Text(
                          widget.product.originalPrice!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Sale price
                        Text(
                          widget.product.price,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    // Regular price
                    Text(
                      widget.product.price,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4d2963),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Determine the navigation URL based on collection context
  String _getNavigationUrl() {
    // If collectionId is explicitly provided, use it
    if (widget.collectionId != null) {
      return '/collections/${widget.collectionId}/products/${widget.product.id}';
    }

    // If product has collectionIds, use the first one (primary collection)
    if (widget.product.primaryCollectionId != null) {
      return '/collections/${widget.product.primaryCollectionId}/products/${widget.product.id}';
    }

    // Fallback to simple product route (for products without collection context)
    return '/product';
  }
}
