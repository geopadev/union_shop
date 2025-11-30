import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/product_option.dart';
import 'package:union_shop/repositories/product_repository.dart';

/// In-memory implementation of ProductRepository
/// Uses hardcoded data with configurable latency for testing
class InMemoryProductRepository implements ProductRepository {
  final Duration latency;

  /// Create repository with optional artificial latency
  /// Set latency to Duration.zero for deterministic tests
  InMemoryProductRepository({
    this.latency = const Duration(milliseconds: 500),
  });

  /// Hardcoded product data
  final List<Product> _products = [
    // Clothing Collection - with size and color options
    Product(
      id: 'classic-hoodie',
      title: 'Classic Hoodie',
      price: '£35.00',
      imageUrl: 'assets/images/products/classic_hoodie.jpg',
      description:
          'A comfortable and stylish classic hoodie featuring the University of Portsmouth Students\' Union logo. Perfect for everyday wear on campus. Made from high-quality cotton blend material.',
      options: [
        ProductOption(
          id: 'size',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
          required: true,
        ),
        ProductOption(
          id: 'color',
          name: 'Color',
          type: ProductOptionType.color,
          values: ['Black', 'Purple', 'White'],
          required: true,
        ),
      ],
    ),
    Product(
      id: 'classic-sweatshirt',
      title: 'Classic Sweatshirt',
      price: '£30.00',
      imageUrl: 'assets/images/products/classic_sweatshirt.jpg',
      description:
          'Cozy classic sweatshirt with UPSU branding. Ideal for layering during colder months. Features a crew neck design and ribbed cuffs.',
      options: [
        ProductOption(
          id: 'size',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['S', 'M', 'L', 'XL'],
          required: true,
        ),
        ProductOption(
          id: 'color',
          name: 'Color',
          type: ProductOptionType.color,
          values: ['Purple', 'Black', 'Grey'],
          required: true,
        ),
      ],
    ),
    Product(
      id: 'polo-shirt',
      title: 'Polo Shirt',
      price: '£18.00',
      imageUrl: 'assets/images/products/polo_shirt.jpg',
      description:
          'Smart casual polo shirt with embroidered UPSU logo. Perfect for more formal campus events or casual wear. Available in multiple colors.',
      options: [
        ProductOption(
          id: 'size',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['XS', 'S', 'M', 'L', 'XL'],
          required: true,
        ),
        ProductOption(
          id: 'color',
          name: 'Color',
          type: ProductOptionType.color,
          values: ['Purple', 'White', 'Black'],
          required: true,
        ),
      ],
    ),
    Product(
      id: 'varsity-jacket',
      title: 'Portsmouth Varsity Jacket',
      price: '£45.00',
      imageUrl: 'assets/images/products/varsity_jacket.jpg',
      description:
          'Premium varsity jacket featuring Portsmouth city colors and UPSU branding. A statement piece combining style with campus pride. Includes snap button closure.',
      options: [
        ProductOption(
          id: 'size',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['S', 'M', 'L', 'XL', 'XXL'],
          required: true,
        ),
      ],
    ),

    // Merchandise - color options only (no size)
    Product(
      id: 'water-bottle',
      title: 'UPSU Water Bottle',
      price: '£12.00',
      imageUrl: 'assets/images/products/water_bottle.jpg',
      description:
          'Reusable stainless steel water bottle with UPSU logo. Keep hydrated throughout your day on campus. 500ml capacity with secure screw-top lid.',
      options: [
        ProductOption(
          id: 'color',
          name: 'Color',
          type: ProductOptionType.color,
          values: ['Purple', 'Black', 'Blue'],
          required: true,
        ),
      ],
    ),
    Product(
      id: 'tote-bag',
      title: 'Tote Bag',
      price: '£6.00',
      imageUrl: 'assets/images/products/tote_bag.jpg',
      description:
          'Practical cotton tote bag perfect for carrying books and essentials. Features the UPSU logo and is environmentally friendly. Strong shoulder straps.',
      options: [
        ProductOption(
          id: 'color',
          name: 'Color',
          type: ProductOptionType.color,
          values: ['Purple', 'Black', 'White'],
          required: true,
        ),
      ],
    ),

    // Products without options
    Product(
      id: 'notebook',
      title: 'Branded Notebook',
      price: '£4.00',
      imageUrl: 'assets/images/products/notebook.jpg',
      description:
          'A5 lined notebook with UPSU branding on the cover. Perfect for lectures and note-taking. Contains 100 pages of quality paper.',
    ),
    Product(
      id: 'lanyard',
      title: 'Lanyard',
      price: '£3.00',
      imageUrl: 'assets/images/products/lanyard.jpg',
      description:
          'Durable lanyard featuring UPSU colors and logo. Keep your student ID card safe and accessible. Includes safety breakaway clasp.',
    ),

    // Portsmouth City Collection
    Product(
      id: 'portsmouth-magnet',
      title: 'Portsmouth City Magnet',
      price: '£3.00',
      imageUrl: 'assets/images/products/portsmouth_magnet.jpg',
      description:
          'Decorative fridge magnet celebrating Portsmouth city landmarks. A perfect souvenir or gift. Features iconic Portsmouth scenery.',
    ),
    Product(
      id: 'portsmouth-mug',
      title: 'Portsmouth Mug',
      price: '£8.00',
      imageUrl: 'assets/images/products/portsmouth_mug.jpg',
      description:
          'Ceramic mug featuring Portsmouth city design. Dishwasher and microwave safe. 11oz capacity, perfect for your morning coffee or tea.',
    ),
    Product(
      id: 'portsmouth-keyring',
      title: 'Portsmouth Keyring',
      price: '£4.00',
      imageUrl: 'assets/images/products/portsmouth_keyring.jpg',
      description:
          'Metal keyring with Portsmouth city branding. Durable and stylish accessory for your keys. Features Spinnaker Tower design.',
    ),
    Product(
      id: 'portsmouth-postcard-set',
      title: 'Portsmouth Postcard Set',
      price: '£5.00',
      imageUrl: 'assets/images/products/portsmouth_postcards.jpg',
      description:
          'Set of 6 postcards featuring beautiful Portsmouth landmarks and scenery. Perfect for sending to friends and family or collecting as keepsakes.',
    ),

    // Pride Collection
    Product(
      id: 'pride-flag',
      title: 'Rainbow Pride Flag',
      price: '£10.00',
      imageUrl: 'assets/images/products/pride_flag.jpg',
      description:
          'Large rainbow pride flag (3ft x 5ft). Show your support for the LGBTQ+ community. Made from durable polyester with reinforced edges.',
    ),
    Product(
      id: 'pride-pin',
      title: 'Pride Pin Badge',
      price: '£3.00',
      imageUrl: 'assets/images/products/pride_pin.jpg',
      description:
          'Enamel pin badge featuring rainbow pride colors. Perfect for attaching to bags, jackets, or lanyards. Metal construction with butterfly clasp.',
    ),
    Product(
      id: 'rainbow-lanyard',
      title: 'Rainbow Lanyard',
      price: '£5.00',
      imageUrl: 'assets/images/products/rainbow_lanyard.jpg',
      description:
          'Colorful rainbow lanyard celebrating pride and diversity. Durable fabric with metal clip and safety breakaway. Support equality with style.',
    ),
    Product(
      id: 'pride-tshirt',
      title: 'Pride T-Shirt',
      price: '£20.00',
      imageUrl: 'assets/images/products/pride_tshirt.jpg',
      description:
          'Comfortable cotton t-shirt featuring pride rainbow design and UPSU logo. Available in multiple sizes. Show your support for LGBTQ+ rights.',
      options: [
        ProductOption(
          id: 'size',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['S', 'M', 'L', 'XL'],
          required: true,
        ),
      ],
    ),

    // Halloween Collection
    Product(
      id: 'halloween-tshirt',
      title: 'Halloween T-Shirt',
      price: '£18.00',
      imageUrl: 'assets/images/products/halloween_tshirt.jpg',
      description:
          'Spooky themed t-shirt perfect for Halloween celebrations. Features fun Halloween graphics and UPSU branding. Limited edition seasonal item.',
      options: [
        ProductOption(
          id: 'size',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['S', 'M', 'L', 'XL'],
          required: true,
        ),
      ],
    ),
    Product(
      id: 'halloween-stickers',
      title: 'Spooky Sticker Pack',
      price: '£4.00',
      imageUrl: 'assets/images/products/halloween_stickers.jpg',
      description:
          'Pack of 10 Halloween-themed stickers. Decorate your laptop, water bottle, or notebook. Waterproof and durable vinyl material.',
    ),
    Product(
      id: 'halloween-tote',
      title: 'Halloween Tote Bag',
      price: '£7.00',
      imageUrl: 'assets/images/products/halloween_tote.jpg',
      description:
          'Canvas tote bag with Halloween design. Perfect for trick-or-treating or carrying Halloween party supplies. Sturdy construction with long handles.',
    ),

    // Graduation Collection
    Product(
      id: 'graduation-bear',
      title: 'Graduation Bear',
      price: '£25.00',
      imageUrl: 'assets/images/products/graduation_bear.jpg',
      description:
          'Adorable teddy bear wearing graduation cap and gown. Perfect gift for celebrating graduation achievements. Approximately 30cm tall, soft and cuddly.',
    ),
    Product(
      id: 'graduation-frame',
      title: 'Graduation Frame',
      price: '£15.00',
      imageUrl: 'assets/images/products/graduation_frame.jpg',
      description:
          'Elegant photo frame designed for graduation photos. Features "Congratulations" engraving and space for 6x4 photo. Perfect keepsake for this special milestone.',
    ),
    Product(
      id: 'graduation-card',
      title: 'Graduation Card',
      price: '£3.00',
      imageUrl: 'assets/images/products/graduation_card.jpg',
      description:
          'Congratulations card for graduation. High-quality card with graduation cap design and space for personal message inside. Includes envelope.',
    ),
  ];

  @override
  Future<List<Product>> fetchAll() async {
    // Simulate network delay
    await Future.delayed(latency);
    return List.unmodifiable(_products);
  }

  @override
  Future<Product?> fetchById(String id) async {
    // Simulate network delay
    await Future.delayed(latency);
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> search(String query) async {
    // Simulate network delay
    await Future.delayed(latency);

    if (query.isEmpty) {
      return _products;
    }

    // Search in product title and description (case-insensitive)
    final lowerQuery = query.toLowerCase();
    return _products.where((product) {
      final titleMatch = product.title.toLowerCase().contains(lowerQuery);
      final descriptionMatch =
          product.description.toLowerCase().contains(lowerQuery);
      return titleMatch || descriptionMatch;
    }).toList();
  }
}
