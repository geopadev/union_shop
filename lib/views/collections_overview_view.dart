import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class CollectionsOverviewPage extends StatelessWidget {
  const CollectionsOverviewPage({super.key});

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

            // Collections Grid
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

                final collections = viewModel.allCollections;

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate responsive columns
                      int crossAxisCount;
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 800) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 2;
                      } else {
                        crossAxisCount = 1;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: collections.length,
                        itemBuilder: (context, index) {
                          return _CollectionCard(
                            collection: collections[index],
                          );
                        },
                      );
                    },
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

class _CollectionCard extends StatefulWidget {
  final dynamic collection;

  const _CollectionCard({
    required this.collection,
  });

  @override
  State<_CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<_CollectionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final collection = widget.collection;

    return GestureDetector(
      onTap: () => context.go('/collections/${collection.id}'),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Collection image
                Positioned.fill(
                  child: Image.asset(
                    collection.imageUrl,
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
                                'Add image:\n${collection.imageUrl}',
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

                // Dark overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),

                // Collection name overlay
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        collection.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
