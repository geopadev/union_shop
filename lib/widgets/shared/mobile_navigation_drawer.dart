import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/data/navigation_data.dart';
import 'package:union_shop/models/navigation_item.dart';

/// Mobile navigation drawer with expandable sections
/// Displays all navigation items in a vertical drawer on mobile devices
class MobileNavigationDrawer extends StatefulWidget {
  const MobileNavigationDrawer({super.key});

  @override
  State<MobileNavigationDrawer> createState() => _MobileNavigationDrawerState();
}

class _MobileNavigationDrawerState extends State<MobileNavigationDrawer> {
  final Set<String> _expandedSections = {};

  void _toggleSection(String title) {
    setState(() {
      if (_expandedSections.contains(title)) {
        _expandedSections.remove(title);
      } else {
        _expandedSections.add(title);
      }
    });
  }

  void _navigateAndClose(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    context.go(route); // Navigate to route
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: const Key('mobile_nav_drawer'),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF4d2963),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: NavigationData.mainNavigation.map((item) {
                  return _buildNavItem(context, item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavigationItem item) {
    if (item.hasDropdown) {
      // Item with dropdown (expandable)
      final isExpanded = _expandedSections.contains(item.title);

      return Column(
        children: [
          ListTile(
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => _toggleSection(item.title),
          ),
          if (isExpanded && item.children != null)
            ...item.children!.map((child) {
              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(
                    child.title,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => _navigateAndClose(context, child.route!),
                ),
              );
            }).toList(),
          const Divider(height: 1),
        ],
      );
    } else {
      // Simple item without dropdown
      return Column(
        children: [
          ListTile(
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _navigateAndClose(context, item.route!),
          ),
          const Divider(height: 1),
        ],
      );
    }
  }
}
