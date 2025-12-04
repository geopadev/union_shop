import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/collection_view_model.dart';
import 'package:union_shop/widgets/shared/mobile_navigation_drawer.dart';
import 'package:union_shop/widgets/shared/shared_header.dart';
import 'package:union_shop/widgets/shared/shared_footer.dart';

class CollectionsPage extends StatefulWidget {
  final String? collectionId;

  const CollectionsPage({super.key, this.collectionId});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  String _sortBy =
      'featured'; // featured, price-asc, price-desc, title-asc, title-desc
  Set<String> _selectedSizes = {};
  Set<String> _selectedColors = {};
  bool _showOnSaleOnly = false;

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  List<Product> _filterAndSortProducts(List<Product> products) {
    var filtered = products.where((product) {
      // Filter by sale status
      if (_showOnSaleOnly && !product.isOnSale) return false;

      // Filter by size
      if (_selectedSizes.isNotEmpty) {
        final sizeOption = product.options?.firstWhere(
          (opt) => opt.name == 'Size',
          orElse: () => null as dynamic,
        );
        if (sizeOption == null) return false;
        final hasMatchingSize =
            sizeOption.values.any((size) => _selectedSizes.contains(size));
        if (!hasMatchingSize) return false;
      }

      // Filter by color
      if (_selectedColors.isNotEmpty) {
        final colorOption = product.options?.firstWhere(
          (opt) => opt.name == 'Color',
          orElse: () => null as dynamic,
        );
        if (colorOption == null) return false;
        final hasMatchingColor =
            colorOption.values.any((color) => _selectedColors.contains(color));
        if (!hasMatchingColor) return false;
      }

      return true;
    }).toList();

    // Sort products
    switch (_sortBy) {
      case 'price-asc':
        filtered.sort((a, b) {
          final priceA =
              double.tryParse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          final priceB =
              double.tryParse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price-desc':
        filtered.sort((a, b) {
          final priceA =
              double.tryParse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          final priceB =
              double.tryParse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'title-asc':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'title-desc':
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'featured':
      default:
        // Keep original order for featured
        break;
    }

    return filtered;
  }

  Set<String> _getAllAvailableSizes(List<Product> products) {
    final sizes = <String>{};
    for (var product in products) {
      final sizeOption = product.options?.firstWhere(
        (opt) => opt.name == 'Size',
        orElse: () => null as dynamic,
      );
      if (sizeOption != null) {
        sizes.addAll(sizeOption.values);
      }
    }
    return sizes;
  }

  Set<String> _getAllAvailableColors(List<Product> products) {
    final colors = <String>{};
    for (var product in products) {
      final colorOption = product.options?.firstWhere(
        (opt) => opt.name == 'Color',
        orElse: () => null as dynamic,
      );
      if (colorOption != null) {
        colors.addAll(colorOption.values);
      }
    }
    return colors;
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

                if (widget.collectionId != null) {
                  collection =
                      viewModel.getCollectionById(widget.collectionId!);
                  products =
                      viewModel.getProductsForCollection(widget.collectionId!);
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

                // Get all available filter options from products
                final availableSizes = _getAllAvailableSizes(products);
                final availableColors = _getAllAvailableColors(products);

                // Apply filtering and sorting
                final filteredProducts = _filterAndSortProducts(products);

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

                          // Filter and Sort Controls
                          Row(
                            children: [
                              // Filters Section (Desktop) / Button (Mobile)
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (constraints.maxWidth > 800) {
                                      // Desktop: Show filters inline
                                      return Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: [
                                          // Sort Dropdown
                                          _buildSortDropdown(),

                                          // Size Filter (if available)
                                          if (availableSizes.isNotEmpty)
                                            _buildSizeFilter(availableSizes),

                                          // Color Filter (if available)
                                          if (availableColors.isNotEmpty)
                                            _buildColorFilter(availableColors),

                                          // Sale Filter
                                          _buildSaleFilter(),
                                        ],
                                      );
                                    } else {
                                      // Mobile: Show filter button
                                      return Row(
                                        children: [
                                          Expanded(child: _buildSortDropdown()),
                                          const SizedBox(width: 12),
                                          OutlinedButton.icon(
                                            onPressed: () => _showMobileFilters(
                                              context,
                                              availableSizes,
                                              availableColors,
                                            ),
                                            icon: const Icon(Icons.filter_list),
                                            label: Text(
                                              'Filters${_getActiveFilterCount() > 0 ? ' (${_getActiveFilterCount()})' : ''}',
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xFF4d2963),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Product Count
                          Text(
                            '${filteredProducts.length} products',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Products Grid
                          if (filteredProducts.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(60),
                                child: Text(
                                  'No products match your filters',
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
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    return _ProductCard(
                                      product: product,
                                      collectionId: widget.collectionId!,
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

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: _sortBy,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down),
        items: const [
          DropdownMenuItem(value: 'featured', child: Text('Featured')),
          DropdownMenuItem(
              value: 'price-asc', child: Text('Price: Low to High')),
          DropdownMenuItem(
              value: 'price-desc', child: Text('Price: High to Low')),
          DropdownMenuItem(value: 'title-asc', child: Text('Name: A to Z')),
          DropdownMenuItem(value: 'title-desc', child: Text('Name: Z to A')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _sortBy = value);
          }
        },
      ),
    );
  }

  Widget _buildSizeFilter(Set<String> availableSizes) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Size${_selectedSizes.isNotEmpty ? ' (${_selectedSizes.length})' : ''}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) {
        final sortedSizes = availableSizes.toList()
          ..sort((a, b) {
            const sizeOrder = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
            final indexA = sizeOrder.indexOf(a);
            final indexB = sizeOrder.indexOf(b);
            if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
            return a.compareTo(b);
          });

        return sortedSizes.map((size) {
          final isSelected = _selectedSizes.contains(size);
          return PopupMenuItem<String>(
            value: size,
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) {
                    setState(() {
                      if (isSelected) {
                        _selectedSizes.remove(size);
                      } else {
                        _selectedSizes.add(size);
                      }
                    });
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF4d2963),
                ),
                Text(size),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (size) {
        setState(() {
          if (_selectedSizes.contains(size)) {
            _selectedSizes.remove(size);
          } else {
            _selectedSizes.add(size);
          }
        });
      },
    );
  }

  Widget _buildColorFilter(Set<String> availableColors) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Color${_selectedColors.isNotEmpty ? ' (${_selectedColors.length})' : ''}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) {
        return availableColors.map((color) {
          final isSelected = _selectedColors.contains(color);
          return PopupMenuItem<String>(
            value: color,
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) {
                    setState(() {
                      if (isSelected) {
                        _selectedColors.remove(color);
                      } else {
                        _selectedColors.add(color);
                      }
                    });
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF4d2963),
                ),
                Text(color),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (color) {
        setState(() {
          if (_selectedColors.contains(color)) {
            _selectedColors.remove(color);
          } else {
            _selectedColors.add(color);
          }
        });
      },
    );
  }

  Widget _buildSaleFilter() {
    return FilterChip(
      label: const Text('On Sale'),
      selected: _showOnSaleOnly,
      onSelected: (selected) {
        setState(() => _showOnSaleOnly = selected);
      },
      selectedColor: const Color(0xFF4d2963).withOpacity(0.2),
      checkmarkColor: const Color(0xFF4d2963),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedSizes.isNotEmpty) count++;
    if (_selectedColors.isNotEmpty) count++;
    if (_showOnSaleOnly) count++;
    return count;
  }

  void _showMobileFilters(
    BuildContext context,
    Set<String> availableSizes,
    Set<String> availableColors,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedSizes.clear();
                            _selectedColors.clear();
                            _showOnSaleOnly = false;
                          });
                          setModalState(() {});
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Size Filter
                  if (availableSizes.isNotEmpty) ...[
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableSizes.map((size) {
                        final isSelected = _selectedSizes.contains(size);
                        return FilterChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSizes.add(size);
                              } else {
                                _selectedSizes.remove(size);
                              }
                            });
                            setModalState(() {});
                          },
                          selectedColor:
                              const Color(0xFF4d2963).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF4d2963),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Color Filter
                  if (availableColors.isNotEmpty) ...[
                    const Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableColors.map((color) {
                        final isSelected = _selectedColors.contains(color);
                        return FilterChip(
                          label: Text(color),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedColors.add(color);
                              } else {
                                _selectedColors.remove(color);
                              }
                            });
                            setModalState(() {});
                          },
                          selectedColor:
                              const Color(0xFF4d2963).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF4d2963),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Sale Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Show On Sale Only',
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: _showOnSaleOnly,
                        onChanged: (value) {
                          setState(() => _showOnSaleOnly = value);
                          setModalState(() {});
                        },
                        activeColor: const Color(0xFF4d2963),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4d2963),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            'Add image:\n${widget.product.imageUrl}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
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
                  Flexible(
                    child: Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product price (compact layout for sale items)
                  if (widget.product.isOnSale &&
                      widget.product.originalPrice != null)
                    // Compact sale price layout
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        // Sale price
                        Text(
                          widget.product.price,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Original price with strikethrough (smaller)
                        Text(
                          widget.product.originalPrice!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  else
                    // Regular price
                    Text(
                      widget.product.price,
                      style: const TextStyle(
                        fontSize: 16,
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
