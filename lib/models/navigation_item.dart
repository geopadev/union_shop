/// Navigation item model representing a menu item in the navigation bar
/// Can have children for dropdown menus
class NavigationItem {
  final String title;
  final String? route;
  final List<NavigationItem>? children;

  const NavigationItem({
    required this.title,
    this.route,
    this.children,
  });

  /// Whether this navigation item has a dropdown menu
  bool get hasDropdown => children != null && children!.isNotEmpty;
}
