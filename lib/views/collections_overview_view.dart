import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class CollectionsOverviewPage extends StatelessWidget {
  const CollectionsOverviewPage({super.key});

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

            // Collections Content
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

                final collections = viewModel.collections;

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
                          // Page Title
                          const Text(
                            'Collections',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${collections.length} collections',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Collections Grid
                          LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount;
                              double childAspectRatio;

                              if (constraints.maxWidth > 1200) {
                                crossAxisCount = 4;
                                childAspectRatio = 0.8;
                              } else if (constraints.maxWidth > 800) {
                                crossAxisCount = 3;
                                childAspectRatio = 0.85;
                              } else if (constraints.maxWidth > 600) {
                                crossAxisCount = 2;
                                childAspectRatio = 0.9;
                              } else {
                                crossAxisCount = 1;
                                childAspectRatio = 1.5;
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                ),
                                itemCount: collections.length,
                                itemBuilder: (context, index) {
                                  final collection = collections[index];
                                  return _CollectionCard(
                                    collectionId: collection.id,
                                    name: collection.name,
                                    description: collection.description,
                                    imageUrl: collection.imageUrl,
                                    productCount: collection.productIds.length,
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

class _CollectionCard extends StatelessWidget {
  final String collectionId;
  final String name;
  final String description;
  final String imageUrl;
  final int productCount;

  const _CollectionCard({
    required this.collectionId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/collections/$collectionId');
      },
      child: Semantics(
        button: true,
        label: 'Collection: $name, $productCount products',
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection Image
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.collections,
                                size: 48, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Collection Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$productCount products',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4d2963),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
