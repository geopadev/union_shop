import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/data/carousel_data.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/home/hero_carousel.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
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

class _ProductCard extends StatelessWidget {
  final dynamic product;
  final String collectionId;

  const _ProductCard({
    required this.product,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/collections/$collectionId/products/${product.id}');
      },
      child: Semantics(
        button: true,
        label: 'Product: ${product.title}, Price: ${product.price}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            AspectRatio(
              aspectRatio: 1.0,
              child: Semantics(
                image: true,
                label: 'Image of ${product.title}',
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
                                color: Colors.grey,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add image:\n${product.imageUrl}',
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
            const SizedBox(height: 12),
            // Product title
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Product price
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF4d2963),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
