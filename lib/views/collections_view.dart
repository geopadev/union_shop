import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class CollectionsPage extends StatelessWidget {
  final String? collectionId;

  const CollectionsPage({super.key, this.collectionId});

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('collections_page'),
      endDrawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SharedHeader(
              onLogoTap: () => navigateToHome(context),
              onSearchTap: placeholderCallbackForButtons,
              onAccountTap: placeholderCallbackForButtons,
              onCartTap: placeholderCallbackForButtons,
              onMenuTap: placeholderCallbackForButtons,
            ),

            // Collection Content
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

                Collection? collection;
                List<Product> products = [];

                if (collectionId != null) {
                  collection = viewModel.getCollectionById(collectionId!);
                  products = viewModel.getProductsForCollection(collectionId!);
                }

                if (collection == null) {
                  return Container(
                    padding: const EdgeInsets.all(60),
                    child: const Center(
                      child: Text(
                        'Collection not found',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                return Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Breadcrumb Navigation
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
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                collection.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Collection Header
                          Text(
                            collection.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            collection.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Product Count
                          Text(
                            '${products.length} products',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Products Grid
                          if (products.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(60),
                                child: Text(
                                  'No products in this collection',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount;
                                double childAspectRatio;

                                if (constraints.maxWidth > 1200) {
                                  crossAxisCount = 4;
                                  childAspectRatio = 0.7;
                                } else if (constraints.maxWidth > 800) {
                                  crossAxisCount = 3;
                                  childAspectRatio = 0.75;
                                } else if (constraints.maxWidth > 600) {
                                  crossAxisCount = 2;
                                  childAspectRatio = 0.8;
                                } else {
                                  crossAxisCount = 1;
                                  childAspectRatio = 1.2;
                                }

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: childAspectRatio,
                                    crossAxisSpacing: 24,
                                    mainAxisSpacing: 48,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return _ProductCard(
                                      product: product,
                                      collectionId: collectionId!,
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 48,
                                ),
                              ),
                            );
                          },
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
    );
  }
}
