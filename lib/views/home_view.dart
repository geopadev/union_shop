// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/data/carousel_data.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/home/hero_carousel.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';
import 'package:union_shop/scripts/upload_products_to_firestore.dart';
import 'package:union_shop/scripts/upload_collections_to_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  Future<void> _uploadDataToFirestore(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF4d2963)),
        ),
      );

      // Upload products
      await uploadProductsToFirestore();

      // Upload collections (uncomment when ready)
      await uploadCollectionsToFirestore();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ All data uploaded to Firestore!'),
            backgroundColor: Color(0xFF4d2963),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
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

            // 🔥 TEMPORARY UPLOAD BUTTON - REMOVE AFTER UPLOADING DATA
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange[100],
              child: Center(
                child: ElevatedButton.icon(
                  key: const Key('upload_firestore_button'),
                  onPressed: () => _uploadDataToFirestore(context),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('UPLOAD PRODUCTS TO FIRESTORE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // 🔥 END OF TEMPORARY BUTTON

            // Hero Carousel
            const HeroCarousel(slides: CarouselData.slides),

            // Featured Collections Sections
            Consumer<CollectionViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return Container(
                    padding: const EdgeInsets.all(60),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4d2963),
                      ),
                    ),
                  );
                }

                // Featured collections to display on homepage
                final featuredCollectionIds = [
                  'signature-essential',
                  'portsmouth',
                  'pride',
                ];

                return Container(
                  color: Colors.white,
                  child: Column(
                    children: featuredCollectionIds.map((collectionId) {
                      final collection =
                          viewModel.getCollectionById(collectionId);
                      if (collection == null) return const SizedBox.shrink();

                      final products =
                          viewModel.getProductsForCollection(collectionId);
                      final displayProducts = products.take(2).toList();

                      return _CollectionSection(
                        collectionId: collectionId,
                        collectionName: collection.name,
                        products: displayProducts,
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            // Footer
            const SharedFooter(),
          ],
        ),
      ),
    );
  }
}

class _CollectionSection extends StatelessWidget {
  final String collectionId;
  final String collectionName;
  final List<dynamic> products;

  const _CollectionSection({
    required this.collectionId,
    required this.collectionName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection heading (clickable)
              GestureDetector(
                onTap: () => context.go('/collections/$collectionId'),
                child: Text(
                  collectionName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4d2963),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Products grid (2 products side by side on desktop, stacked on mobile)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 600;

                  if (isDesktop) {
                    // Desktop: products side by side
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: products.map((product) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: _ProductCard(
                              product: product,
                              collectionId: collectionId,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    // Mobile: products stacked
                    return Column(
                      children: products.map((product) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _ProductCard(
                            product: product,
                            collectionId: collectionId,
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final dynamic product;
  final String collectionId;

  const _ProductCard({
    required this.product,
    required this.collectionId,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          context.go(
              '/collections/${widget.collectionId}/products/${widget.product.id}');
        },
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
}
