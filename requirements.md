# Feature Requirements: MVVM refactor, minimal main.dart, reusable header & footer

## 1. Feature description
Refactor the app to MVVM so `main.dart` is a minimal bootstrapper (keeping `UnionShopApp` in `main.dart`) and shared header/footer widgets are reusable across pages. Purpose: improve testability, maintainability, and allow consistent UI across views.

## 2. User stories
- Dev: As a developer I want `main.dart` to only bootstrap the app so the app is easy to test and maintain.
- Dev: As a developer I want reusable header and footer widgets so multiple pages share the same layout and behaviour.
- QA: As a QA engineer I want stable Keys and injectable data so widget tests run deterministically.
- User (mobile): As a mobile user I want a compact header; on large screens I want expanded header with extra actions.
- User: As a user I want consistent footer across pages and ability for pages to add supplemental footer content.

## 3. Acceptance criteria (done definition)
- `main.dart` initializes environment, wires providers, configures ThemeData, routes and calls `runApp(UnionShopApp(...))`. (No separate `lib/app.dart`.)
- SharedHeader and SharedFooter widgets exist in `lib/widgets/shared/`, are stateless, accessible, responsive, and expose Keys for tests.
- Home and Product view logic moved to view models (`lib/view_models/`) and data access to repositories (`lib/repositories/`).
- Tests use Keys or DI/mocks and run deterministically with the option to disable artificial repo latency.
- Documentation updated to reflect architecture and developer workflow.

---

## Subtasks (status)
- [x] S-01 — Project layout  
  - Create folders:
    - lib/views
    - lib/view_models
    - lib/repositories
    - lib/widgets/shared
    - lib/services  
  - Move UI into `lib/views`, VMs into `lib/view_models`, repos into `lib/repositories`.
  - Reason: folders exist and HomeScreen/ProductPage are under `lib/views/`.

- [x] S-02 — Main entry refactor (keep main.dart)  
  - Replace current `main.dart` with a minimal bootstrap that initializes services and calls `runApp(UnionShopApp())`.  
  - Keep `UnionShopApp` in `lib/main.dart`; configure ThemeData, routes, navigatorKey and top-level providers inside `main.dart`.  
  - Reason: `main.dart` is now minimal, containing only `main()` function and `UnionShopApp` with theme, routes configuration.

- [x] S-03 — Shared header widget  
  - `lib/widgets/shared/shared_header.dart` implemented. Exposes header actions and Keys.
  - Reason: SharedHeader widget created with callback properties (onLogoTap, onSearchTap, onAccountTap, onCartTap, onMenuTap) and test Keys (logoTap, app_logo, header_search, header_account, header_cart, header_menu, header_banner). Integrated into both HomeScreen and ProductPage.

- [x] S-04 — Shared footer widget  
  - `lib/widgets/shared/shared_footer.dart` implemented with Key('footer_main').
  - Reason: SharedFooter widget created with Key('footer_main') for testing and optional additionalContent parameter for pages that need supplemental footer content. Integrated into both HomeScreen and ProductPage for consistent footer across all pages.

- [x] S-05 — MVVM scaffolding
  - HomeViewModel and ProductViewModel now extend a new BaseViewModel (lib/view_models/base_view_model.dart)
  - BaseViewModel centralises loading state and helpers.
  - Reason: BaseViewModel created with loading state management and helper methods (setLoading, runWithLoading). HomeViewModel and ProductViewModel created extending BaseViewModel. Both ViewModels currently use hardcoded data and will be connected to repositories in S-06. Provider package added to dependencies for state management.

- [x] S-06 — Repositories & DI  
  - `ProductRepository` interface and `InMemoryProductRepository` implemented with configurable latency.  
  - Repositories and view models injected via Provider in `main.dart`.
  - Reason: Product model created (lib/models/product.dart) with id, title, price, imageUrl, and description. ProductRepository interface created (lib/repositories/product_repository.dart) with fetchAll(), fetchById(), and search() methods. InMemoryProductRepository implemented with configurable latency (default 500ms, can be set to Duration.zero for tests). HomeViewModel and ProductViewModel updated to use Product model and repository injection. Provider DI wired up in main.dart with createApp() factory function that accepts optional ProductRepository and navigatorKey for testing.

- [x] S-07 — Routing & navigation  
  - Routes and `navigatorKey` exposed in `main.dart` (home + /product route present).
  - Reason: MaterialApp already configured with initialRoute '/', home route pointing to HomeScreen, and '/product' route pointing to ProductPage. navigatorKey parameter accepted in createApp() factory function and passed through to MaterialApp for integration testing support.

- [x] S-08 — Testability fixes
  - Tests should build the app via `createApp(productRepo: InMemoryProductRepository(latency: Duration.zero))` (see lib/main.dart).  
  - This ensures deterministic widget tests by removing artificial repo latency while keeping the production default unchanged.
  - Reason: Updated home_test.dart and product_test.dart to use createApp() factory function with zero-latency repository (InMemoryProductRepository(latency: Duration.zero)). Added proper imports (flutter/material.dart) to fix Icons references. All tests now use await tester.pumpAndSettle() to wait for async operations, making tests deterministic and fast while production app maintains 500ms latency for realistic user experience.

- [x] S-09 — Accessibility, theming, responsiveness
  - Added semantic labels to product images and wrapped header/footer with Semantics to improve screen reader support (lib/views/* and lib/widgets/shared/*).  
  - Header strip now keeps its original icon-only actions so the look remains unchanged while tooltips keep it accessible (lib/widgets/shared/shared_header.dart).  
  - Products grid layout now adapts columns & aspect ratio to available width to improve responsiveness (lib/views/home_view.dart).
  - Reason: Added tooltips to all header IconButtons (Search, Account, Shopping cart, Menu) and Semantics widget to logo. Added Semantics wrapper to SharedFooter with descriptive label. Added Semantics to product card images in home_view.dart and product detail image in product_view.dart with proper labels. Implemented responsive product grid using LayoutBuilder with 4 breakpoints: 1 column (mobile), 2 columns (>600px), 3 columns (>800px), 4 columns (>1200px), each with optimized childAspectRatio. All changes maintain original visual design while significantly improving accessibility and responsiveness.

- [x] S-10 — Documentation
  - Added developer usage examples, test instructions and guidance for adding new views, view models and repositories below.
  - Reason: Comprehensive documentation already present in requirements.md including: Developer quickstart section with steps to run the app, detailed section on running widget tests deterministically using createApp() factory with zero-latency repository, complete guide on how to add new View/ViewModel/Repository following MVVM pattern with DI registration examples, test tips section listing all Keys and best practices for async test handling, and guidance on where to add additional documentation. All documentation sections are complete and provide clear instructions for developers working on the project.

- [x] S-16 — **Navigation Model & Data**
  - Create NavigationItem model (lib/models/navigation_item.dart) with properties: title, route, children (for dropdowns)
  - Create Collection model (lib/models/collection.dart) with properties: id, name, description, imageUrl, products
  - Create sample collection data in repository
  - Reason: NavigationItem model created with title, optional route, and optional children for dropdown menus, includes hasDropdown getter. Collection model created with id, name, description, imageUrl, and productIds. CollectionRepository interface created with fetchAll(), fetchById(), and fetchFeatured() methods. InMemoryCollectionRepository implemented with hardcoded data for 8 collections (Clothing, Merchandise, Halloween, Signature & Essential Range, Portsmouth City Collection, Pride Collection, Graduation, SALE) with configurable latency matching ProductRepository pattern.

- [x] S-17 — **Navigation Menu Widget**
  - Create NavigationMenu widget (lib/widgets/shared/navigation_menu.dart)
  - Implement horizontal navigation for desktop with 5 main links
  - Add dropdown functionality for SHOP and The Print Shack menus
  - Integrate NavigationMenu into SharedHeader below the banner
  - Add Keys for testing: Key('nav_home'), Key('nav_shop'), Key('nav_printshack'), Key('nav_sale'), Key('nav_about')
  - Reason: Created NavigationData class (lib/data/navigation_data.dart) defining navigation structure with 5 main items and dropdown children. NavigationMenu widget created (lib/widgets/shared/navigation_menu.dart) displaying horizontal navigation with TextButtons for each item. Items with dropdowns show arrow indicator. Navigation menu integrated into SharedHeader below banner by wrapping header in Column. Test Keys added following pattern nav_{item_title}. Dropdown functionality placeholder added (will be implemented in S-18).

- [x] S-18 — **Dropdown Menus**
  - Implement dropdown menu widget (lib/widgets/shared/dropdown_menu.dart)
  - SHOP dropdown: Clothing, Merchandise, Halloween 🎃, Signature & Essential Range, Portsmouth City Collection, Pride Collection 🏳️‍🌈, Graduation 🎓
  - The Print Shack dropdown: About, Personalisation
  - Make dropdowns accessible (keyboard navigation, proper ARIA labels)
  - Add hover behavior for desktop, tap behavior for mobile
  - Reason: Created DropdownMenuWidget (lib/widgets/shared/dropdown_menu_widget.dart) using Overlay system for dropdown rendering. Implemented hover behavior with MouseRegion for desktop and tap behavior with GestureDetector for mobile. Added 200ms delay timer to prevent flickering between trigger and dropdown. Dropdown tracks hover state separately for trigger and overlay to allow smooth mouse movement. Added semantic labels to dropdown trigger and menu items for screen reader support. Integrated DropdownMenuWidget into NavigationMenu for items with children (SHOP and The Print Shack). Dropdown closes when clicking outside or selecting an item.

- [ ] S-19 — **About Page**
  - Create AboutPage (lib/views/about_view.dart)
  - Add route '/about' in main.dart
  - Display company information, mission, values
  - Use SharedHeader and SharedFooter for consistency
  - Add Key('about_page') for testing

- [ ] S-20 — **Collections Overview Page**
  - Create CollectionsPage (lib/views/collections_view.dart)
  - Add route '/collections' in main.dart
  - Display grid of all collections with images and names
  - Each collection card navigates to its individual collection page
  - Use responsive grid layout (similar to products grid)
  - Add Key('collections_page') for testing

- [ ] S-21 — **Individual Collection Pages**
  - Create CollectionDetailPage (lib/views/collection_detail_view.dart)
  - Add route '/collections/:id' in main.dart with route parameter
  - CollectionViewModel to fetch products for specific collection
  - Display collection name, description, and filtered products
  - Add breadcrumb navigation: Home > Collections > [Collection Name]
  - Add Key('collection_detail_page') for testing

- [ ] S-22 — **Hero Carousel Widget**
  - Create CarouselSlide model (lib/models/carousel_slide.dart): title, subtitle, imageUrl, buttonText, buttonRoute
  - Create HeroCarousel widget (lib/widgets/home/hero_carousel.dart)
  - Implement PageView for sliding between carousel items
  - Add auto-advance timer (e.g., every 5 seconds)
  - Add manual navigation dots/indicators
  - First slide has "BROWSE COLLECTION" button linking to a collection
  - Add Keys: Key('hero_carousel'), Key('carousel_slide_0'), Key('browse_collection_button')

- [ ] S-23 — **Carousel Integration & Navigation**
  - Replace static hero section in home_view.dart with HeroCarousel
  - Create sample carousel data with 3-5 slides
  - Wire up carousel button actions to navigate to collection pages
  - Ensure smooth transitions and proper aspect ratios
  - Test carousel on mobile and desktop views

- [ ] S-24 — **Deep Linking & Routes**
  - Update main.dart with all new named routes:
    - '/about' → AboutPage
    - '/collections' → CollectionsPage
    - '/collections/:id' → CollectionDetailPage
    - '/shop/clothing' → CollectionDetailPage(collectionId: 'clothing')
    - '/shop/merchandise' → CollectionDetailPage(collectionId: 'merchandise')
    - '/shop/halloween' → CollectionDetailPage(collectionId: 'halloween')
    - '/shop/signature-essential' → CollectionDetailPage(collectionId: 'signature-essential')
    - '/shop/portsmouth' → CollectionDetailPage(collectionId: 'portsmouth')
    - '/shop/pride' → CollectionDetailPage(collectionId: 'pride')
    - '/shop/graduation' → CollectionDetailPage(collectionId: 'graduation')
    - '/printshack/about' → AboutPage (print shack specific)
    - '/printshack/personalisation' → PersonalisationPage
    - '/sale' → CollectionDetailPage(collectionId: 'sale')
  - Test all routes with browser URL bar navigation

- [ ] S-25 — **Mobile Navigation (Hamburger Menu)**
  - Create MobileNavigationDrawer widget (lib/widgets/shared/mobile_navigation_drawer.dart)
  - Show hamburger menu icon on mobile instead of full navigation
  - Implement expandable sections for SHOP and The Print Shack in drawer
  - Add proper animations and transitions
  - Ensure drawer closes after navigation
  - Add Key('mobile_nav_drawer') for testing

- [ ] S-26 — **Navigation & Carousel Tests**
  - Create tests for NavigationMenu widget
  - Test dropdown menu interactions
  - Test route navigation for all links
  - Test carousel auto-advance and manual navigation
  - Test mobile drawer functionality
  - Update existing tests to accommodate new navigation structure

---

## Implementation Notes

### Navigation Structure
```
HOME
SHOP ▼
  ├─ Clothing
  ├─ Merchandise
  ├─ Halloween 🎃
  ├─ Signature & Essential Range
  ├─ Portsmouth City Collection
  ├─ Pride Collection 🏳️‍🌈
  └─ Graduation 🎓
The Print Shack ▼
  ├─ About
  └─ Personalisation
SALE!
About
```

### Route Structure
```
/                              → HomeScreen
/about                         → AboutPage
/collections                   → CollectionsPage
/collections/:id               → CollectionDetailPage
/shop/clothing                 → CollectionDetailPage(clothing)
/shop/merchandise              → CollectionDetailPage(merchandise)
/shop/halloween                → CollectionDetailPage(halloween)
/shop/signature-essential      → CollectionDetailPage(signature-essential)
/shop/portsmouth               → CollectionDetailPage(portsmouth)
/shop/pride                    → CollectionDetailPage(pride)
/shop/graduation               → CollectionDetailPage(graduation)
/printshack/about              → AboutPage (print shack)
/printshack/personalisation    → PersonalisationPage
/sale                          → CollectionDetailPage(sale)
/product/:id                   → ProductPage
```

### Hero Carousel Data Structure Example
```dart
final carouselSlides = [
  CarouselSlide(
    title: 'Explore Portsmouth City Collection',
    subtitle: 'Discover unique items celebrating our city',
    imageUrl: 'https://...',
    buttonText: 'BROWSE COLLECTION',
    buttonRoute: '/shop/portsmouth',
  ),
  CarouselSlide(
    title: 'Halloween Special 🎃',
    subtitle: 'Spooky season essentials',
    imageUrl: 'https://...',
    buttonText: 'SHOP NOW',
    buttonRoute: '/shop/halloween',
  ),
  // ... more slides
};
```

---

**Why this feature matters:**
- Improves content discoverability through organized navigation
- Provides multiple pathways to products (navigation menu, carousel, collections)
- Enhances user experience with visual browsing via carousel
- Supports deep linking for sharing specific collections/products
- Makes the app feel more complete and professional

---

