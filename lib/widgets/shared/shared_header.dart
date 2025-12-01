import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/view_models/cart_view_model.dart';
import 'package:union_shop/services/auth_service.dart'; // Changed from auth_view_model.dart
import 'package:union_shop/widgets/shared/navigation_menu.dart';
import 'package:go_router/go_router.dart';

class SharedHeader extends StatelessWidget {
  final VoidCallback? onLogoTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAccountTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onMenuTap;

  const SharedHeader({
    super.key,
    this.onLogoTap,
    this.onSearchTap,
    this.onAccountTap,
    this.onCartTap,
    this.onMenuTap,
  });

  void _openMobileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: AppColors.secondary,
          child: Column(
            children: [
              // Top banner
              Container(
                key: const Key('header_banner'),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: AppColors.primary,
                child: const Text(
                  'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.secondary, fontSize: 16),
                ),
              ),
              // Main header
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      key: const Key('logoTap'),
                      onTap: onLogoTap,
                      child: Semantics(
                        label: 'University of Portsmouth Students Union logo',
                        button: true,
                        child: Image.network(
                          'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                          key: const Key('app_logo'),
                          height: 18,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              width: 18,
                              height: 18,
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Check if we're on a narrow screen
                        final isNarrowScreen =
                            MediaQuery.of(context).size.width < 768;

                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                key: const Key('header_search'),
                                icon: const Icon(
                                  Icons.search,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                tooltip: 'Search',
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: () => context.go('/search'),
                              ),
                              // Account icon
                              IconButton(
                                key: const Key('header_account'),
                                icon: const Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                tooltip: 'Account',
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: () {
                                  // Check auth state and navigate accordingly
                                  final authService = Provider.of<AuthService>(
                                    context,
                                    listen: false,
                                  );
                                  final isSignedIn =
                                      authService.currentUser != null;

                                  if (isSignedIn) {
                                    context.go('/account');
                                  } else {
                                    context.go('/account/login');
                                  }
                                },
                              ),
                              // Cart icon with badge
                              Consumer<CartViewModel>(
                                builder: (context, cartViewModel, child) {
                                  final itemCount = cartViewModel.totalItems;
                                  return Stack(
                                    children: [
                                      IconButton(
                                        key: const Key('header_cart'),
                                        icon: const Icon(
                                          Icons.shopping_bag_outlined,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        tooltip: 'Shopping cart',
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                        onPressed: onCartTap,
                                      ),
                                      if (itemCount > 0)
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              itemCount > 9
                                                  ? '9+'
                                                  : '$itemCount',
                                              style: const TextStyle(
                                                color: AppColors.secondary,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              // Only show hamburger menu on narrow screens
                              if (isNarrowScreen)
                                IconButton(
                                  key: const Key('header_menu'),
                                  icon: const Icon(
                                    Icons.menu,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Menu',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  onPressed: () => _openMobileDrawer(context),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Navigation Menu
        const NavigationMenu(),
      ],
    );
  }
}
