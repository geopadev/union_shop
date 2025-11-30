/// Represents a navigation menu item in the application's navigation bar.
///
/// A [NavigationItem] can be a simple link or contain child items to create
/// a dropdown menu. Use the [hasDropdown] getter to determine if this item
/// should display a dropdown.
///
/// Example:
/// ```dart
/// const homeItem = NavigationItem(
///   title: 'Home',
///   route: '/',
/// );
///
/// const shopDropdown = NavigationItem(
///   title: 'Shop',
///   children: [
///     NavigationItem(title: 'Clothing', route: '/collections/clothing'),
///     NavigationItem(title: 'Accessories', route: '/collections/accessories'),
///   ],
/// );
/// ```
class NavigationItem {
  /// The display title of this navigation item.
  final String title;

  /// The route path this item navigates to when clicked.
  ///
  /// Should be null for items with [children] (dropdown menus).
  final String? route;

  /// Child navigation items for creating dropdown menus.
  ///
  /// If this list is not empty, the navigation item will display as a dropdown.
  final List<NavigationItem>? children;

  /// Creates a navigation item.
  ///
  /// Either [route] or [children] should be provided, but typically not both.
  const NavigationItem({
    required this.title,
    this.route,
    this.children,
  });

  /// Whether this navigation item has a dropdown menu.
  ///
  /// Returns `true` if [children] is not null and not empty.
  bool get hasDropdown => children != null && children!.isNotEmpty;
}
