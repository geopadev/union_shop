import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/models/product.dart';

class CollectionsPage extends StatelessWidget {
  final String? collectionId;

  const CollectionsPage({super.key, this.collectionId});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('collections_page'),
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
                                onTap: () => Navigator.pushNamed(context, '/'),
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
                                    return _ProductCard(product: product);
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

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // Get collection context from the page
    final collectionId =
        context.findAncestorWidgetOfExactType<CollectionsPage>()?.collectionId;

    return GestureDetector(
      onTap: () {
        // Navigate with collection context if available
        if (collectionId != null) {
          Navigator.pushNamed(
            context,
            '/collections/$collectionId/products/${product.id}',
          );
        } else {
          // Fallback to old route if no collection context
          Navigator.pushNamed(context, '/product');
        }
      },
      child: Semantics(
        button: true,
        label: 'Product: ${product.title}, Price: ${product.price}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Semantics(
                image: true,
                label: 'Image of ${product.title}',
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child:
                            Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4d2963),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
