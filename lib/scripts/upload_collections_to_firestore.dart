import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future<void> uploadCollectionsToFirestore() async {
  print('🚀 Starting collections upload...');

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

  // All 8 collections
  final collections = [
    {
      'id': 'clothing',
      'name': 'Clothing',
      'description':
          'Discover our range of high-quality clothing featuring the UPSU brand',
      'imageUrl': 'assets/images/collections/clothing.jpg',
      'productIds': [
        'classic-hoodie',
        'classic-sweatshirt',
        'polo-shirt',
        'portsmouth-varsity-jacket',
        'pride-t-shirt'
      ]
    },
    {
      'id': 'merchandise',
      'name': 'Merchandise',
      'description': 'Essential UPSU branded merchandise and accessories',
      'imageUrl': 'assets/images/collections/merchandise.jpg',
      'productIds': [
        'upsu-water-bottle',
        'tote-bag',
        'branded-notebook',
        'lanyard',
        'portsmouth-city-magnet',
        'pride-pin-badge'
      ]
    },
    {
      'id': 'halloween',
      'name': 'Halloween 🎃',
      'description': 'Spooky season essentials and Halloween themed items',
      'imageUrl': 'assets/images/collections/halloween.jpg',
      'productIds': [
        'halloween-t-shirt',
        'spooky-sticker-pack',
        'halloween-tote-bag'
      ]
    },
    {
      'id': 'signature-essential',
      'name': 'Signature & Essential Range',
      'description': 'Our core collection of UPSU branded essentials',
      'imageUrl': 'assets/images/collections/signature.jpg',
      'productIds': [
        'classic-hoodie',
        'classic-sweatshirt',
        'polo-shirt',
        'upsu-water-bottle',
        'tote-bag',
        'branded-notebook',
        'lanyard'
      ]
    },
    {
      'id': 'portsmouth',
      'name': 'Portsmouth City Collection',
      'description': 'Celebrate Portsmouth with our city-themed collection',
      'imageUrl': 'assets/images/collections/portsmouth.jpg',
      'productIds': [
        'portsmouth-varsity-jacket',
        'portsmouth-city-magnet',
        'portsmouth-mug',
        'portsmouth-keyring',
        'portsmouth-postcard-set'
      ]
    },
    {
      'id': 'pride',
      'name': 'Pride Collection 🏳️‍🌈',
      'description': 'Show your pride with our rainbow collection',
      'imageUrl': 'assets/images/collections/pride.jpg',
      'productIds': [
        'pride-t-shirt',
        'rainbow-pride-flag',
        'pride-pin-badge',
        'rainbow-lanyard'
      ]
    },
    {
      'id': 'graduation',
      'name': 'Graduation',
      'description': 'Commemorate your graduation with our special collection',
      'imageUrl': 'assets/images/collections/graduation.jpg',
      'productIds': ['graduation-bear', 'graduation-frame', 'graduation-card']
    },
    {
      'id': 'sale',
      'name': 'SALE!',
      'description':
          'Amazing deals on selected items - grab them while stock lasts!',
      'imageUrl': 'assets/images/collections/sale.jpg',
      'productIds': [
        'tote-bag',
        'branded-notebook',
        'halloween-t-shirt',
        'spooky-sticker-pack',
        'halloween-tote-bag'
      ]
    },
  ];

  // Upload each collection
  int count = 0;
  for (var collection in collections) {
    await db
        .collection('collections')
        .doc(collection['id'] as String)
        .set(collection);
    count++;
    print('✅ Uploaded ($count/${collections.length}): ${collection['name']}');
  }

  print('🎉 Successfully uploaded $count collections to Firestore!');
}

void main() async {
  await uploadCollectionsToFirestore();
}
