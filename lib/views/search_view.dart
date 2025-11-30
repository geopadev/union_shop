import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/search_view_model.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');

    // Perform initial search if query provided
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SearchViewModel>().search(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // Placeholder for buttons that don't work yet
  }

  void _performSearch(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchViewModel>().search(query);
      // Update URL with search query
      context.go('/search?q=${Uri.encodeComponent(query)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('search_page'),
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

            // Search Page Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title
                      const Text(
                        'Search Products',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('search_input'),
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for products...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              onSubmitted: (_) => _performSearch(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _performSearch(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4d2963),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Search'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Search Results
                      Consumer<SearchViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(60),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF4d2963),
                                ),
                              ),
                            );
                          }

                          if (!viewModel.hasSearched) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(60),
                                child: Text(
                                  'Enter a search term to find products',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (viewModel.noResults) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(60),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No results found for "${viewModel.currentQuery}"',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Try different keywords or browse our collections',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Display search results
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${viewModel.searchResults.length} results for "${viewModel.currentQuery}"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildProductGrid(viewModel.searchResults),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            const SharedFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
          childAspectRatio = 0.75;
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _ProductCard(
              key: Key('search_result_$index'),
              product: products[index],
            );
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product without collection context
        context.go('/product');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.imageUrl,
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
    );
  }
}
