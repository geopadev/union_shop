import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future<void> uploadProductsToFirestore() async {
  print('🚀 Starting Firestore upload...');

  // Check if Firebase is already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized, continue
    print('Firebase already initialized');
  }

  final db = FirebaseFirestore.instance;

  // All 24 products with complete data
  final products = [
    // CLOTHING COLLECTION (5 products)
    {
      'id': 'classic-hoodie',
      'title': 'Classic Hoodie',
      'price': '£35.00',
      'description':
          'Premium quality hoodie featuring the UPSU logo. Perfect for everyday wear with soft, comfortable fabric. Available in multiple colors and sizes.',
      'imageUrl': 'assets/images/products/classic_hoodie.jpg',
      'collectionIds': [
        'clothing',
        'signature-essential',
        'portsmouth',
        'pride',
        'halloween',
        'sale'
      ],
      'isOnSale': false,
      'originalPrice': '',
      'options': [
        {
          'id': 'size',
          'name': 'Size',
          'type': 'size',
          'required': true,
          'values': ['XS', 'S', 'M', 'L', 'XL', 'XXL']
        },
        {
          'id': 'color',
          'name': 'Color',
          'type': 'color',
          'required': true,
          'values': ['Purple', 'Black', 'White', 'Grey']
        }
      ]
    },
    {
      'id': 'classic-sweatshirt',
      'title': 'Classic Sweatshirt',
      'price': '£30.00',
      'description':
          'Comfortable sweatshirt with UPSU branding. Made from high-quality cotton blend for warmth and comfort.',
      'imageUrl': 'assets/images/products/classic_sweatshirt.jpg',
      'collectionIds': ['clothing', 'signature-essential'],
      'isOnSale': false,
      'originalPrice': '',
      'options': [
        {
          'id': 'size',
          'name': 'Size',
          'type': 'size',
          'required': true,
          'values': ['XS', 'S', 'M', 'L', 'XL', 'XXL']
        },
        {
          'id': 'color',
          'name': 'Color',
          'type': 'color',
          'required': true,
          'values': ['Purple', 'Black', 'Grey']
        }
      ]
    },
    {
      'id': 'polo-shirt',
      'title': 'Polo Shirt',
      'price': '£18.00',
      'description':
          'Classic polo shirt with embroidered UPSU logo. Smart casual wear perfect for events.',
      'imageUrl': 'assets/images/products/polo_shirt.jpg',
      'collectionIds': ['clothing', 'signature-essential'],
      'isOnSale': false,
      'originalPrice': '',
      'options': [
        {
          'id': 'size',
          'name': 'Size',
          'type': 'size',
          'required': true,
          'values': ['S', 'M', 'L', 'XL', 'XXL']
        },
        {
          'id': 'color',
          'name': 'Color',
          'type': 'color',
          'required': true,
          'values': ['Purple', 'White', 'Black']
        }
      ]
    },
    {
      'id': 'portsmouth-varsity-jacket',
      'title': 'Portsmouth Varsity Jacket',
      'price': '£45.00',
      'description':
          'Premium varsity jacket celebrating Portsmouth. Features high-quality embroidery and comfortable fit.',
      'imageUrl': 'assets/images/products/portsmouth_varsity_jacket.jpg',
      'collectionIds': ['clothing', 'portsmouth'],
      'isOnSale': false,
      'originalPrice': '',
      'options': [
        {
          'id': 'size',
          'name': 'Size',
          'type': 'size',
          'required': true,
          'values': ['S', 'M', 'L', 'XL', 'XXL']
        }
      ]
    },
    {
      'id': 'pride-t-shirt',
      'title': 'Pride T-Shirt',
      'price': '£20.00',
      'description':
          'Show your support with our Pride rainbow t-shirt. Comfortable cotton fabric with vibrant design.',
      'imageUrl': 'assets/images/products/pride_t_shirt.jpg',
      'collectionIds': ['clothing', 'pride'],
      'isOnSale': false,
      'originalPrice': '',
      'options': [
        {
          'id': 'size',
          'name': 'Size',
          'type': 'size',
          'required': true,
          'values': ['S', 'M', 'L', 'XL']
        }
      ]
    },

    // MERCHANDISE COLLECTION (5 products)
    {
      'id': 'upsu-water-bottle',
      'title': 'UPSU Water Bottle',
      'price': '£12.00',
      'description':
          'Reusable water bottle with UPSU logo. 500ml capacity, BPA-free materials.',
      'imageUrl': 'assets/images/products/upsu_water_bottle.jpg',
      'collectionIds': ['merchandise', 'signature-essential'],
      'isOnSale': false,
      'originalPrice': '',
      'options': [
        {
          'id': 'color',
          'name': 'Color',
          'type': 'color',
          'required': true,
          'values': ['Purple', 'Black', 'White']
        }
      ]
    },
    {
      'id': 'tote-bag',
      'title': 'Tote Bag',
      'price': '£4.00',
      'description':
          'Eco-friendly tote bag with UPSU branding. Perfect for shopping and daily use.',
      'imageUrl': 'assets/images/products/tote_bag.jpg',
      'collectionIds': ['merchandise', 'signature-essential', 'sale'],
      'isOnSale': true,
      'originalPrice': '£6.00',
      'options': [
        {
          'id': 'color',
          'name': 'Color',
          'type': 'color',
          'required': true,
          'values': ['Purple', 'Black']
        }
      ]
    },
    {
      'id': 'branded-notebook',
      'title': 'Branded Notebook',
      'price': '£2.50',
      'description':
          'A5 notebook with UPSU branding. 100 pages, perfect for lectures and notes.',
      'imageUrl': 'assets/images/products/branded_notebook.jpg',
      'collectionIds': ['merchandise', 'signature-essential', 'sale'],
      'isOnSale': true,
      'originalPrice': '£4.00',
    },
    {
      'id': 'lanyard',
      'title': 'Lanyard',
      'price': '£3.00',
      'description':
          'UPSU branded lanyard with safety breakaway. Perfect for ID cards and keys.',
      'imageUrl': 'assets/images/products/lanyard.jpg',
      'collectionIds': ['merchandise', 'signature-essential'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'portsmouth-city-magnet',
      'title': 'Portsmouth City Magnet',
      'price': '£3.00',
      'description':
          'Commemorative Portsmouth fridge magnet. Great souvenir or gift.',
      'imageUrl': 'assets/images/products/portsmouth_city_magnet.jpg',
      'collectionIds': ['merchandise', 'portsmouth'],
      'isOnSale': false,
      'originalPrice': '',
    },

    // PORTSMOUTH CITY COLLECTION (5 products)
    {
      'id': 'portsmouth-mug',
      'title': 'Portsmouth Mug',
      'price': '£8.00',
      'description':
          'Ceramic mug featuring Portsmouth landmarks. Dishwasher safe.',
      'imageUrl': 'assets/images/products/portsmouth_mug.jpg',
      'collectionIds': ['portsmouth'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'portsmouth-keyring',
      'title': 'Portsmouth Keyring',
      'price': '£4.00',
      'description': 'Metal keyring with Portsmouth Spinnaker Tower design.',
      'imageUrl': 'assets/images/products/portsmouth_keyring.jpg',
      'collectionIds': ['portsmouth'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'portsmouth-postcard-set',
      'title': 'Portsmouth Postcard Set',
      'price': '£5.00',
      'description':
          'Set of 6 postcards featuring Portsmouth attractions and landmarks.',
      'imageUrl': 'assets/images/products/portsmouth_postcard_set.jpg',
      'collectionIds': ['portsmouth'],
      'isOnSale': false,
      'originalPrice': '',
    },

    // PRIDE COLLECTION (4 products)
    {
      'id': 'rainbow-pride-flag',
      'title': 'Rainbow Pride Flag',
      'price': '£10.00',
      'description': 'Large rainbow pride flag. 150cm x 90cm, vibrant colors.',
      'imageUrl': 'assets/images/products/rainbow_pride_flag.jpg',
      'collectionIds': ['pride'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'pride-pin-badge',
      'title': 'Pride Pin Badge',
      'price': '£3.00',
      'description': 'Rainbow pride pin badge. Metal with secure clasp.',
      'imageUrl': 'assets/images/products/pride_pin_badge.jpg',
      'collectionIds': ['pride', 'merchandise'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'rainbow-lanyard',
      'title': 'Rainbow Lanyard',
      'price': '£5.00',
      'description':
          'Pride rainbow lanyard with UPSU branding. Safety breakaway included.',
      'imageUrl': 'assets/images/products/rainbow_lanyard.jpg',
      'collectionIds': ['pride'],
      'isOnSale': false,
      'originalPrice': '',
    },

    // HALLOWEEN COLLECTION (3 products)
    {
      'id': 'halloween-t-shirt',
      'title': 'Halloween T-Shirt',
      'price': '£12.00',
      'description': 'Spooky Halloween themed t-shirt. Limited edition design.',
      'imageUrl': 'assets/images/products/halloween_t_shirt.jpg',
      'collectionIds': ['halloween', 'sale'],
      'isOnSale': true,
      'originalPrice': '£18.00',
      'options': [
        {
          'id': 'size',
          'name': 'Size',
          'type': 'size',
          'required': true,
          'values': ['S', 'M', 'L', 'XL']
        }
      ]
    },
    {
      'id': 'spooky-sticker-pack',
      'title': 'Spooky Sticker Pack',
      'price': '£2.50',
      'description':
          'Pack of 10 Halloween themed stickers. Waterproof and durable.',
      'imageUrl': 'assets/images/products/spooky_sticker_pack.jpg',
      'collectionIds': ['halloween', 'sale'],
      'isOnSale': true,
      'originalPrice': '£4.00',
    },
    {
      'id': 'halloween-tote-bag',
      'title': 'Halloween Tote Bag',
      'price': '£5.00',
      'description': 'Halloween themed tote bag with spooky design.',
      'imageUrl': 'assets/images/products/halloween_tote_bag.jpg',
      'collectionIds': ['halloween', 'sale'],
      'isOnSale': true,
      'originalPrice': '£7.00',
    },

    // GRADUATION COLLECTION (3 products)
    {
      'id': 'graduation-bear',
      'title': 'Graduation Bear',
      'price': '£25.00',
      'description':
          'Commemorative graduation teddy bear wearing academic cap and gown.',
      'imageUrl': 'assets/images/products/graduation_bear.jpg',
      'collectionIds': ['graduation'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'graduation-frame',
      'title': 'Graduation Frame',
      'price': '£15.00',
      'description':
          'Photo frame designed for graduation certificates and photos.',
      'imageUrl': 'assets/images/products/graduation_frame.jpg',
      'collectionIds': ['graduation'],
      'isOnSale': false,
      'originalPrice': '',
    },
    {
      'id': 'graduation-card',
      'title': 'Graduation Card',
      'price': '£3.00',
      'description': 'Congratulations graduation card with envelope.',
      'imageUrl': 'assets/images/products/graduation_card.jpg',
      'collectionIds': ['graduation'],
      'isOnSale': false,
      'originalPrice': '',
    },
  ];

  // Upload each product
  int count = 0;
  for (var product in products) {
    await db.collection('products').doc(product['id'] as String).set(product);
    count++;
    print('✅ Uploaded ($count/${products.length}): ${product['title']}');
  }

  print('🎉 Successfully uploaded $count products to Firestore!');
}

void main() async {
  await uploadProductsToFirestore();
}
