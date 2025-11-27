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
          route: '/shop/clothing',
        ),
        NavigationItem(
          title: 'Merchandise',
          route: '/shop/merchandise',
        ),
        NavigationItem(
          title: 'Halloween 🎃',
          route: '/shop/halloween',
        ),
        NavigationItem(
          title: 'Signature & Essential Range',
          route: '/shop/signature-essential',
        ),
        NavigationItem(
          title: 'Portsmouth City Collection',
          route: '/shop/portsmouth',
        ),
        NavigationItem(
          title: 'Pride Collection 🏳️‍🌈',
          route: '/shop/pride',
        ),
        NavigationItem(
          title: 'Graduation 🎓',
          route: '/shop/graduation',
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
      route: '/sale',
    ),
    NavigationItem(
      title: 'About',
      route: '/about',
    ),
  ];
}
