import 'package:union_shop/models/navigation_item.dart';

/// Navigation menu structure for the application
/// Defines the 5 main navigation items with their dropdowns
class NavigationData {
  static const List<NavigationItem> mainNavigation = [
    NavigationItem(
      title: 'HOME',
      route: '/',
    ),
    NavigationItem(
      title: 'SHOP',
      children: [
        NavigationItem(
          title: 'Clothing',
          route: '/collections/clothing',
        ),
        NavigationItem(
          title: 'Merchandise',
          route: '/collections/merchandise',
        ),
        NavigationItem(
          title: 'Halloween 🎃',
          route: '/collections/halloween',
        ),
        NavigationItem(
          title: 'Signature & Essential Range',
          route: '/collections/signature-essential',
        ),
        NavigationItem(
          title: 'Portsmouth City Collection',
          route: '/collections/portsmouth',
        ),
        NavigationItem(
          title: 'Pride Collection 🏳️‍🌈',
          route: '/collections/pride',
        ),
        NavigationItem(
          title: 'Graduation 🎓',
          route: '/collections/graduation',
        ),
      ],
    ),
    NavigationItem(
      title: 'The Print Shack',
      children: [
        NavigationItem(
          title: 'About',
          route: '/printshack/about',
        ),
        NavigationItem(
          title: 'Personalisation',
          route: '/printshack/personalisation',
        ),
      ],
    ),
    NavigationItem(
      title: 'SALE!',
      route: '/collections/sale',
    ),
    NavigationItem(
      title: 'About',
      route: '/about',
    ),
  ];
}
