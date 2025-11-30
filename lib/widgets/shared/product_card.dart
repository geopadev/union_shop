import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/constants/app_spacing.dart';
import 'package:union_shop/constants/app_text_styles.dart';
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
            transform: _isHovering
                ? (Matrix4.identity()..scale(1.03))
                : Matrix4.identity(),
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
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusM),
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
                                        Icon(
                                          Icons.image_not_supported,
                                          color: AppColors.textSecondary,
                                          size: AppSpacing.iconXL,
                                        ),
                                        SizedBox(height: AppSpacing.paddingS),
                                        Text(
                                          'Add image:\n${widget.product.imageUrl}',
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
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
                          top: AppSpacing.paddingS,
                          right: AppSpacing.paddingS,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.paddingS,
                              vertical: AppSpacing.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sale,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusS),
                            ),
                            child: const Text(
                              'SALE',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.paddingM),
                  // Product title
                  Text(
                    widget.product.title,
                    style: AppTextStyles.productTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.paddingS),
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
                        SizedBox(height: AppSpacing.paddingXS),
                        // Sale price
                        Text(
                          widget.product.price,
                          style: AppTextStyles.productPriceSale,
                        ),
                      ],
                    )
                  else
                    // Regular price
                    Text(
                      widget.product.price,
                      style: AppTextStyles.productPrice,
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
