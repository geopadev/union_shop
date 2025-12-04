# Union Shop - University of Portsmouth Students' Union E-commerce App

A modern, full-featured Flutter e-commerce application for the University of Portsmouth Students' Union, built with clean MVVM architecture, Firebase backend, and comprehensive testing.

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![Tests](https://img.shields.io/badge/Tests-439%20Passing-brightgreen)
![Coverage](https://img.shields.io/badge/Coverage-52.97%25-yellow)

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Firebase Setup](#-firebase-setup)
- [Testing](#-testing)
- [Development Guide](#-development-guide)
- [Configuration](#-configuration)
- [Deployment](#-deployment)

---

## ✨ Features

### 🛍️ E-Commerce Core
- **Product Catalog**: Browse 24+ university-branded products across multiple collections
- **Collections**: 8 curated collections (Clothing, Merchandise, Portsmouth City, Pride, Halloween, Graduation, Sale)
- **Shopping Cart**: Guest and authenticated user cart management with Firebase sync
- **Product Search**: Real-time product search across title and description
- **Product Details**: Rich product pages with image galleries, descriptions, and customization options

### 🔐 Authentication
- **Firebase Authentication**: Secure email/password authentication
- **Guest Mode**: Browse and shop without account creation
- **Cart Persistence**: Guest carts automatically merge with user carts on sign-in
- **Dynamic Cart Switching**: Seamless cart repository updates based on auth state

### 🎨 User Experience
- **Responsive Design**: Optimized layouts for mobile, tablet, and desktop (breakpoints at 600px, 800px, 1200px)
- **Hero Carousel**: Featured collections slider on homepage
- **Navigation Menu**: Multi-level dropdown navigation with hover/tap interactions
- **Breadcrumb Navigation**: Context-aware breadcrumbs showing collection hierarchy
- **Deep Linking**: Full URL routing support with browser back/forward navigation
- **Accessibility**: WCAG compliant with semantic labels, tooltips, and keyboard navigation

### 🏪 Collections System
- **Multi-Collection Products**: Products can belong to multiple collections simultaneously
- **Nested URLs**: Context-aware URLs like `/collections/clothing/products/classic-hoodie`
- **Featured Collections**: Curated collections showcased on homepage
- **Dynamic Filtering**: Products filtered by collection with live counts

### 🎓 University Branding
- **Portsmouth Theme**: University purple (#6B46C1) primary color scheme
- **UPSU Branding**: Consistent university branding across all products
- **Local Pride**: Portsmouth City collection celebrating local landmarks
- **Diversity Support**: Pride Collection with rainbow-themed merchandise

---

## 🏗️ Architecture

### MVVM Pattern

The app follows a clean **Model-View-ViewModel (MVVM)** architecture for separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                         View Layer                          │
│  (lib/views/)                                               │
│  - home_view.dart, product_view.dart, cart_view.dart       │
│  - Stateless/Stateful widgets that render UI                │
│  - Listen to ViewModels via Provider/Consumer               │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ notifyListeners()
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     ViewModel Layer                         │
│  (lib/view_models/)                                         │
│  - HomeViewModel, ProductViewModel, CartViewModel          │
│  - Extend ChangeNotifier for state management              │
│  - Business logic, loading states, error handling           │
│  - Call repository methods, transform data for views        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ async calls
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Repository Layer                         │
│  (lib/repositories/)                                        │
│  - ProductRepository, CollectionRepository, CartRepository  │
│  - Abstract interfaces + concrete implementations           │
│  - FirestoreProductRepository, FirestoreCartRepository      │
│  - Data fetching from Firebase or local storage            │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ Firebase SDK
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Sources                           │
│  - Firebase Firestore (products, collections, carts)        │
│  - Firebase Auth (user authentication)                      │
│  - Local storage (guest cart, in-memory fallbacks)          │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Principles

1. **Dependency Injection**: ViewModels receive repositories via constructor injection
2. **Interface-Based Design**: Repositories implement abstract interfaces for testability
3. **State Management**: Provider package for reactive state propagation
4. **Single Responsibility**: Each layer has clear, focused responsibilities
5. **Testability**: All layers can be independently tested with mocks

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point, Firebase init, DI setup
├── firebase_options.dart              # Firebase configuration
│
├── models/                            # Data models (immutable classes)
│   ├── product.dart                   # Product with options, collections
│   ├── collection.dart                # Collection with product IDs
│   ├── cart.dart                      # Shopping cart model
│   ├── cart_item.dart                 # Individual cart item
│   ├── navigation_item.dart           # Navigation menu structure
│   └── carousel_slide.dart            # Homepage carousel data
│
├── views/                             # UI screens (Flutter widgets)
│   ├── home_view.dart                 # Homepage with carousel, featured products
│   ├── product_view.dart              # Product detail page
│   ├── cart_view.dart                 # Shopping cart screen
│   ├── collections_overview_view.dart # All collections grid
│   ├── collections_view.dart          # Single collection products
│   ├── search_view.dart               # Product search results
│   ├── about_view.dart                # About page
│   ├── auth/                          # Authentication screens
│   │   ├── login_view.dart
│   │   └── signup_view.dart
│   └── printshack/                    # Print shop personalization
│       └── personalization_view.dart
│
├── view_models/                       # Business logic, state management
│   ├── base_view_model.dart           # Base class with loading state
│   ├── home_view_model.dart           # Homepage logic
│   ├── product_view_model.dart        # Product details logic
│   ├── cart_view_model.dart           # Cart operations
│   ├── collection_view_model.dart     # Collections logic
│   └── search_view_model.dart         # Search functionality
│
├── repositories/                      # Data access layer (interfaces + implementations)
│   ├── product_repository.dart        # Abstract product data interface
│   ├── firestore_product_repository.dart  # Firestore products implementation
│   ├── collection_repository.dart     # Abstract collection interface
│   ├── firestore_collection_repository.dart
│   ├── cart_repository.dart           # Abstract cart interface
│   └── firestore_cart_repository.dart # Firestore + in-memory cart
│
├── services/                          # External service integrations
│   ├── auth_service.dart              # Firebase Auth wrapper
│   └── firebase_test.dart             # Firebase connection testing
│
├── router/                            # Navigation and routing
│   └── app_router.dart                # GoRouter configuration with deep linking
│
├── widgets/                           # Reusable UI components
│   └── shared/
│       ├── shared_header.dart         # App header with nav, cart badge
│       ├── shared_footer.dart         # App footer with links
│       ├── navigation_menu.dart       # Main navigation bar
│       └── dropdown_menu_widget.dart  # Dropdown navigation menus
│
├── data/                              # Static data and constants
│   ├── navigation_data.dart           # Navigation menu structure
│   ├── footer_data.dart               # Footer links data
│   └── carousel_data.dart             # Homepage carousel slides
│
├── constants/                         # App-wide constants
│   ├── app_colors.dart                # Color palette
│   ├── app_spacing.dart               # Spacing constants
│   └── app_text_styles.dart           # Text styles
│
└── scripts/                           # Utility scripts
    └── upload_products_to_firestore.dart  # Seed Firestore with products

test/
├── helpers/                           # Test utilities
│   ├── test_helpers.dart              # Factory methods for test data
│   └── firebase_test_setup.dart       # Firebase mocking for tests
│
├── models/                            # Model unit tests
├── view_models/                       # ViewModel unit tests
├── repositories/                      # Repository unit tests
├── views/                             # Widget/integration tests
└── widgets/                           # Reusable widget tests
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.0.0 or higher ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: 2.17.0 or higher (included with Flutter)
- **Firebase Account**: For backend services ([Firebase Console](https://console.firebase.google.com/))
- **IDE**: VS Code (recommended) or Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/geopadev/union_shop.git
   cd union_shop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (see [Firebase Setup](#-firebase-setup) section)

4. **Run the app**
   ```bash
   flutter run -d chrome  # Web
   flutter run -d windows # Windows desktop
   flutter run            # Default device
   ```

### Quick Start Development Workflow

```bash
# Run app in development
flutter run -d chrome

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format lib/ test/

# Build for production
flutter build web
```

---

## 🔥 Firebase Setup

### Firebase Configuration

The app uses three Firebase services:

1. **Firebase Authentication** - User sign-in/sign-up
2. **Cloud Firestore** - Product catalog, collections, user carts
3. **Firebase Core** - Initialization and configuration

### Setup Steps

#### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the wizard
3. Name your project (e.g., "union-shop")

#### 2. Enable Firebase Services

**Enable Authentication:**
- Navigate to **Build > Authentication**
- Click "Get started"
- Enable **Email/Password** provider
- Save changes

**Enable Firestore:**
- Navigate to **Build > Firestore Database**
- Click "Create database"
- Choose **Test mode** (for development) or **Production mode**
- Select a region (choose closest to your users)

#### 3. Register Your App

**For Web:**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase for your Flutter project
flutterfire configure
```

The CLI will:
- Create `lib/firebase_options.dart` with your configuration
- Register your app in Firebase console
- Configure platforms (Web, Android, iOS, Windows, macOS)

**Manual Configuration** (if needed):
1. In Firebase Console, click the web icon (</>)
2. Register your app
3. Copy the Firebase config
4. Update `lib/firebase_options.dart`

#### 4. Configure Firestore Security Rules

In Firebase Console > Firestore Database > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Products collection (public read)
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Admin only (manage via console)
    }
    
    // Collections (public read)
    match /collections/{collectionId} {
      allow read: if true;
      allow write: if false; // Admin only
    }
    
    // User carts (authenticated users only)
    match /users/{userId}/cart/{cartItemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### 5. Seed Initial Data

Run the data upload script to populate Firestore:

```bash
# From project root
dart run lib/scripts/upload_products_to_firestore.dart
```

This will upload:
- **24 products** (hoodies, t-shirts, merchandise, etc.)
- **8 collections** (Clothing, Merchandise, Portsmouth, Pride, etc.)

### Firebase Configuration Files

- `lib/firebase_options.dart` - Generated by FlutterFire CLI
- `android/app/google-services.json` - Android config (auto-generated)
- `ios/Runner/GoogleService-Info.plist` - iOS config (auto-generated)
- `firebase.json` - Firebase project configuration

### Verify Firebase Connection

The app includes a connection test that runs on startup:

```dart
// lib/services/firebase_test.dart
await testFirebaseConnection();
```

Check the console for:
```
✅ Firebase initialized: [DEFAULT]
✅ Firebase Auth available: [DEFAULT]
✅ Firestore available: [DEFAULT]
🎉 All Firebase services are connected!
```

---

## 🧪 Testing

### Test Coverage: 52.97% (607/1146 lines)

The app includes **439 passing tests** covering models, view models, repositories, views, and widgets.

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/view_models/home_view_model_test.dart

# Run tests matching a pattern
flutter test --name "Cart"

# Watch mode (re-run on file changes)
flutter test --watch
```

### Test Organization

```
test/
├── models/              # Model unit tests (data validation)
├── view_models/         # ViewModel unit tests (business logic)
├── repositories/        # Repository unit tests (data access)
├── views/               # Widget/integration tests (UI behavior)
├── widgets/             # Reusable widget tests
└── helpers/             # Test utilities and mocks
```

### Firebase Testing Strategy

Testing Firebase-integrated code requires special handling since Firebase can't run in Flutter test environment. The app uses a **multi-layered testing approach**:

#### 1. Firebase Mock Setup

The test suite uses `firebase_test_setup.dart` to mock Firebase Core:

```dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/firebase_test_setup.dart';

void main() {
  // Setup mocks before any Firebase calls
  setupFirebaseCoreMocks();
  
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  
  // Your tests...
}
```

**How it works:**
- `MockFirebasePlatform` provides fake Firebase initialization
- Prevents "Firebase not initialized" errors in tests
- Uses `firebase_core_platform_interface` to intercept Firebase calls
- Returns fake `FirebaseAppPlatform` with dummy credentials

#### 2. Repository Testing Approach

Firebase repositories are tested using different strategies:

**Guest Cart Testing** (In-Memory):
```dart
test('should add item to guest cart', () async {
  // Guest carts use in-memory storage (no Firebase needed)
  final repository = FirestoreCartRepository(userId: null);
  
  await repository.addItem(testProduct, 2);
  final cart = await repository.getCart();
  
  expect(cart.items.length, 1);
  expect(cart.items[0].quantity, 2);
});
```

**Authenticated User Testing** (Limitations):
```dart
// ⚠️ Current limitation: Firestore repositories use FirebaseFirestore.instance
// directly without dependency injection, making full mocking difficult.

test('authenticated user cart operations', () async {
  // This test documents the API but has limited coverage
  // Real Firestore calls would require:
  // 1. Refactoring to accept FirebaseFirestore as constructor param
  // 2. Using fake_cloud_firestore package for testing
  // 3. Integration tests with Firebase emulator
});
```

#### 3. Test Packages Used

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4                    # Mock generation
  build_runner: ^2.4.8               # Code generation
  fake_cloud_firestore: ^3.0.3      # Firestore mocking (future use)
  firebase_auth_mocks: ^0.14.1       # Auth mocking (future use)
  firebase_core_platform_interface: ^6.0.2  # Core mocking
```

#### 4. Testing Best Practices

**✅ DO:**
- Use `setupFirebaseCoreMocks()` before Firebase initialization
- Test guest cart operations (in-memory, no Firebase needed)
- Test business logic in ViewModels independently
- Mock repositories when testing ViewModels:
  ```dart
  final mockRepo = MockProductRepository();
  when(mockRepo.fetchAll()).thenAnswer((_) async => [testProduct]);
  final viewModel = HomeViewModel(mockRepo);
  ```
- Test widget rendering and interactions
- Use `await tester.pumpAndSettle()` for async operations

**❌ DON'T:**
- Try to test real Firestore operations without emulator
- Assume Firebase services work in test environment
- Skip test setup helpers (causes "Firebase not initialized" errors)

#### 5. Future Testing Improvements

To achieve higher coverage, consider:

1. **Dependency Injection for Firestore:**
   ```dart
   class FirestoreProductRepository implements ProductRepository {
     final FirebaseFirestore firestore;
     
     FirestoreProductRepository({FirebaseFirestore? firestore})
       : firestore = firestore ?? FirebaseFirestore.instance;
   }
   ```

2. **Use FakeFirebaseFirestore:**
   ```dart
   import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
   
   final fakeFirestore = FakeFirebaseFirestore();
   final repository = FirestoreProductRepository(firestore: fakeFirestore);
   ```

3. **Firebase Emulator Suite:**
   ```bash
   firebase emulators:start
   flutter test --dart-define=USE_FIREBASE_EMULATOR=true
   ```

### Test Keys Reference

Key widgets include test keys for reliable widget testing:

**Navigation:**
- `Key('nav_home')` - Home navigation link
- `Key('nav_shop')` - Shop dropdown trigger
- `Key('nav_sale')` - Sale navigation link

**Header:**
- `Key('header_search')` - Search button
- `Key('header_account')` - Account button
- `Key('header_cart')` - Cart button
- `Key('app_logo')` - Logo image

**Footer:**
- `Key('footer_main')` - Main footer widget

**Pages:**
- `Key('home_page')` - Home view
- `Key('product_page')` - Product detail view
- `Key('cart_page')` - Cart view
- `Key('collections_page')` - Collections view
- `Key('about_page')` - About page

### Example Test: ViewModel with Mock Repository

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/view_models/home_view_model.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/models/product.dart';

@GenerateMocks([ProductRepository])
import 'home_view_model_test.mocks.dart';

void main() {
  late MockProductRepository mockRepo;
  late HomeViewModel viewModel;

  setUp(() {
    mockRepo = MockProductRepository();
    viewModel = HomeViewModel(mockRepo);
  });

  test('should fetch featured products on init', () async {
    // Arrange
    final products = [
      Product(id: '1', title: 'Hoodie', price: '£35.00', imageUrl: 'url', description: 'desc'),
    ];
    when(mockRepo.fetchAll()).thenAnswer((_) async => products);

    // Act
    await viewModel.fetchFeaturedProducts();

    // Assert
    expect(viewModel.featuredProducts.length, 1);
    expect(viewModel.isLoading, false);
    verify(mockRepo.fetchAll()).called(1);
  });
}
```

---

## 👨‍💻 Development Guide

### Adding a New View

1. **Create the View Widget** (`lib/views/`)
   ```dart
   // lib/views/my_new_view.dart
   import 'package:flutter/material.dart';
   import 'package:provider/provider.dart';
   
   class MyNewView extends StatelessWidget {
     const MyNewView({super.key});
     
     @override
     Widget build(BuildContext context) {
       final viewModel = context.watch<MyViewModel>();
       
       return Scaffold(
         body: Consumer<MyViewModel>(
           builder: (context, vm, child) {
             if (vm.isLoading) {
               return const Center(child: CircularProgressIndicator());
             }
             return Text(vm.data);
           },
         ),
       );
     }
   }
   ```

2. **Create the ViewModel** (`lib/view_models/`)
   ```dart
   // lib/view_models/my_view_model.dart
   import 'package:union_shop/view_models/base_view_model.dart';
   
   class MyViewModel extends BaseViewModel {
     final MyRepository _repository;
     String _data = '';
     
     String get data => _data;
     
     MyViewModel(this._repository);
     
     Future<void> fetchData() async {
       await runWithLoading(() async {
         _data = await _repository.getData();
         notifyListeners();
       });
     }
   }
   ```

3. **Add Route** (`lib/router/app_router.dart`)
   ```dart
   GoRoute(
     path: '/my-new-page',
     builder: (context, state) => const MyNewView(),
   ),
   ```

4. **Register ViewModel in DI** (`lib/main.dart`)
   ```dart
   ChangeNotifierProvider<MyViewModel>(
     create: (_) => MyViewModel(myRepository),
   ),
   ```

### Adding a New Repository

1. **Define Interface** (`lib/repositories/`)
   ```dart
   // lib/repositories/my_repository.dart
   abstract class MyRepository {
     Future<List<MyModel>> fetchAll();
     Future<MyModel?> fetchById(String id);
   }
   ```

2. **Implement Firestore Version**
   ```dart
   // lib/repositories/firestore_my_repository.dart
   import 'package:cloud_firestore/cloud_firestore.dart';
   
   class FirestoreMyRepository implements MyRepository {
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
     
     @override
     Future<List<MyModel>> fetchAll() async {
       final snapshot = await _firestore.collection('myCollection').get();
       return snapshot.docs
           .map((doc) => MyModel.fromMap(doc.data()))
           .toList();
     }
     
     @override
     Future<MyModel?> fetchById(String id) async {
       final doc = await _firestore.collection('myCollection').doc(id).get();
       return doc.exists ? MyModel.fromMap(doc.data()!) : null;
     }
   }
   ```

3. **Register in DI** (`lib/main.dart`)
   ```dart
   final myRepository = FirestoreMyRepository();
   
   Provider<MyRepository>.value(value: myRepository),
   ```

### Adding a New Test

```dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/firebase_test_setup.dart';

void main() {
  setupFirebaseCoreMocks();
  
  group('MyFeature', () {
    setUp(() {
      // Setup before each test
    });
    
    tearDown(() {
      // Cleanup after each test
    });
    
    test('should do something', () {
      // Arrange
      final expected = 'value';
      
      // Act
      final result = myFunction();
      
      // Assert
      expect(result, expected);
    });
  });
}
```

### Code Style Guidelines

- **Formatting**: Use `dart format` (2 spaces, trailing commas)
- **Naming**: 
  - Classes: `PascalCase`
  - Files: `snake_case.dart`
  - Variables: `camelCase`
  - Constants: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Imports**: Group by `dart:`, `package:`, relative, then alphabetically
- **Keys**: Use `Key('descriptive_name')` for testable widgets
- **Comments**: Document public APIs, explain complex logic
- **Async**: Use `async`/`await`, avoid `.then()` chains

---

## ⚙️ Configuration

### App Constants

**Colors** (`lib/constants/app_colors.dart`)
```dart
static const primaryPurple = Color(0xFF6B46C1);  // University purple
static const navyBlue = Color(0xFF1E293B);       // Portsmouth theme
static const accentOrange = Color(0xFFFF6B35);   // Halloween
```

**Spacing** (`lib/constants/app_spacing.dart`)
```dart
static const xs = 4.0;
static const sm = 8.0;
static const md = 16.0;
static const lg = 24.0;
static const xl = 32.0;
```

**Responsive Breakpoints**
```dart
static const mobileBreakpoint = 600.0;
static const tabletBreakpoint = 800.0;
static const desktopBreakpoint = 1200.0;
```

### Environment Variables

Create `.env` file in project root (not committed to Git):

```env
FIREBASE_API_KEY=your_api_key_here
FIREBASE_PROJECT_ID=your_project_id
```

---

## 🚢 Deployment

### Web Deployment

```bash
# Build for production
flutter build web --release

# Output is in: build/web/
# Deploy to Firebase Hosting:
firebase deploy --only hosting
```

### Windows Desktop

```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

### Android/iOS

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📚 Additional Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)

### Internal Docs
- `requirements.md` - Detailed feature requirements and subtask tracking
- `FIREBASE_SETUP_CHECKLIST.md` - Firebase setup guide
- `GEMINI_IMAGE_PROMPTS.md` - AI image generation prompts for assets

### Project Links
- **Repository**: https://github.com/geopadev/union_shop
- **Firebase Console**: https://console.firebase.google.com/
- **UPSU Shop (Reference)**: https://shop.upsu.net

---

## 👥 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Message Convention

```
type(scope): subject

body

footer
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(cart): add guest cart merge on sign-in

- Implement cart merging logic in CartViewModel
- Add tests for merge scenarios
- Update documentation

Closes #123
```

---

## 📝 License

This project is developed for the University of Portsmouth Students' Union.

---

## 🙏 Acknowledgments

- University of Portsmouth Students' Union for project requirements
- Flutter team for the excellent framework
- Firebase team for backend infrastructure
- Open source community for packages used in this project

---



*Last Updated: December 4, 2025*
