import 'package:flutter/material.dart';
import 'package:union_shop/data/navigation_data.dart';
import 'package:union_shop/models/navigation_item.dart';

/// Navigation menu widget displayed below the header banner
/// Shows horizontal navigation on desktop, integrates with dropdown menus
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  void _handleNavigation(BuildContext context, String? route) {
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: NavigationData.mainNavigation.map((item) {
          return _buildNavItem(context, item);
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavigationItem item) {
    final key = Key('nav_${item.title.toLowerCase().replaceAll(' ', '_')}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        key: key,
        onPressed: item.hasDropdown
            ? null // Will be replaced with dropdown functionality in S-18
            : () => _handleNavigation(context, item.route),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: item.hasDropdown ? Colors.grey[700] : Colors.black,
              ),
            ),
            if (item.hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Colors.grey[700],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
