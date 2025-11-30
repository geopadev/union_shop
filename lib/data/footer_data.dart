import 'package:union_shop/models/navigation_item.dart';

/// Footer data structure containing all footer sections and links
class FooterData {
  /// Shop section links (collections)
  static const List<NavigationItem> shopLinks = [
    NavigationItem(
      title: 'Clothing',
      route: '/collections/clothing',
    ),
    NavigationItem(
      title: 'Merchandise',
      route: '/collections/merchandise',
    ),
    NavigationItem(
      title: 'Portsmouth City Collection',
      route: '/collections/portsmouth',
    ),
    NavigationItem(
      title: 'Pride Collection',
      route: '/collections/pride',
    ),
    NavigationItem(
      title: 'Graduation',
      route: '/collections/graduation',
    ),
    NavigationItem(
      title: 'Sale Items',
      route: '/collections/sale',
    ),
  ];

  /// Help section links
  static const List<NavigationItem> helpLinks = [
    NavigationItem(
      title: 'Contact Us',
      route: null, // Placeholder
    ),
    NavigationItem(
      title: 'Delivery Information',
      route: null, // Placeholder
    ),
    NavigationItem(
      title: 'Returns Policy',
      route: null, // Placeholder
    ),
    NavigationItem(
      title: 'Terms & Conditions',
      route: null, // Placeholder
    ),
    NavigationItem(
      title: 'Privacy Policy',
      route: null, // Placeholder
    ),
  ];

  /// About section links
  static const List<NavigationItem> aboutLinks = [
    NavigationItem(
      title: 'About Us',
      route: '/about',
    ),
    NavigationItem(
      title: 'Store Location',
      route: null, // Placeholder
    ),
    NavigationItem(
      title: 'Opening Hours',
      route: null, // Placeholder
    ),
  ];

  /// Social media links
  static const Map<String, String> socialLinks = {
    'Facebook': 'https://www.facebook.com/upsu',
    'Instagram': 'https://www.instagram.com/upsu/',
    'Twitter': 'https://twitter.com/upsu',
  };

  /// Copyright text
  static const String copyright =
      '© 2024 University of Portsmouth Students\' Union. All rights reserved.';

  /// Newsletter placeholder text
  static const String newsletterTitle = 'Sign up for exclusive offers';
  static const String newsletterDescription =
      'Subscribe to our newsletter and be the first to know about new products and special offers.';
}
