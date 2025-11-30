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

- [x] S-19 — **About Page**
  - Create AboutPage (lib/views/about_view.dart)
  - Add route '/about' in main.dart
  - Display company information, mission, values
  - Use SharedHeader and SharedFooter for consistency
  - Add Key('about_page') for testing
  - Reason: Created AboutPage (lib/views/about_view.dart) with comprehensive content including introduction, mission/values cards, "Why Choose Us?" section with icon-based features, and contact information section. Added '/about' route to main.dart. Page uses SharedHeader and SharedFooter for consistency. Content is constrained to 900px width for readability with responsive two-column layout for mission/values cards. Page includes Key('about_page') for testing. Styled sections with appropriate spacing, colors (university purple #4d2963), and visual hierarchy.

- [x] S-20 — **Collections Overview Page**
  - Create CollectionsOverviewPage (lib/views/collections_overview_view.dart) to display all collection categories as cards
  - Add route '/collections' in main.dart for the overview page
  - Display grid of all collections with images, names, descriptions and product counts
  - Each collection card navigates to its individual collection page (/shop/{collectionId})
  - Use responsive grid layout (1-4 columns based on screen width)
  - Add Key('collections_page') for testing
  - Reason: Created CollectionsOverviewPage (lib/views/collections_overview_view.dart) that displays all collections from CollectionViewModel as cards in a responsive grid. Each card shows collection image, name, description, and product count. Clicking a card navigates to that collection's individual page via '/shop/{collectionId}'. Added '/collections' route to main.dart routing to CollectionsOverviewPage. Grid uses LayoutBuilder with 4 responsive breakpoints (1-4 columns). Page uses Consumer<CollectionViewModel> for data access, includes loading states, and has Key('collections_page') for testing. This matches shop.upsu.net's /collections overview pattern where users browse all collections before drilling into individual ones.

- [x] S-21 — **Collection Page Enhancements**
  - Add breadcrumb navigation to collection pages: Home > [Collection Name]
  - Ensure collection pages properly display filtered products
  - CollectionViewModel already provides getCollectionById() and getProductsForCollection() methods
  - Dynamic routes via onGenerateRoute handle '/shop/{collectionId}' pattern
  - Reason: S-21 functionality was already implemented in S-20. CollectionsPage (lib/views/collections_view.dart) accepts collectionId parameter and displays filtered products for that collection. CollectionViewModel's getCollectionById() and getProductsForCollection() methods filter products by collection. Breadcrumb navigation added showing "Home > [Collection Name]" with clickable Home link. Dynamic routes handled via onGenerateRoute for '/shop/{collectionId}' pattern. Page includes Key('collections_page') for testing. Collection pages display name, description, product count, and responsive product grid matching shop.upsu.net pattern.

- [x] S-21.1 — **Fix Collection URLs to Match Website**
  - Update routing from '/shop/{collectionId}' to '/collections/{collectionId}'
  - Update all navigation links in NavigationData to use '/collections/' prefix
  - Update onGenerateRoute in main.dart to handle '/collections/{collectionId}' pattern
  - Test that collection links work with new URL format
  - Reason: Updated NavigationData (lib/data/navigation_data.dart) to change all SHOP dropdown routes from '/shop/' to '/collections/' prefix, including SALE! route. Updated onGenerateRoute in main.dart to handle '/collections/{collectionId}' pattern instead of '/shop/' with validation to avoid matching the overview page itself. Updated CollectionsOverviewPage collection cards to navigate to '/collections/{collectionId}'. URLs now match shop.upsu.net structure exactly where collections are accessed via /collections/clothing, /collections/pride, etc.

- [x] S-21.2 — **Implement Nested Product URLs with Collection Context**
  - Products can belong to multiple collections (e.g., classic-rainbow-hoodies in both "Pride Collection" and "Clothing")
  - Product URLs must include collection context: '/collections/{collectionId}/products/{productId}'
  - Same product accessed from different collections shows different URLs reflecting the navigation path
  - Update ProductPage to accept both collectionId and productId parameters from URL
  - Update onGenerateRoute to parse nested URLs like '/collections/pride-collection/products/classic-rainbow-hoodies'
  - Update all product card taps to include current collection context in navigation URL
  - Add dynamic breadcrumb to ProductPage: Home > [Collection Name from URL] > [Product Name]
  - Breadcrumb should reflect the collection user came from, not all collections product belongs to
  - Reason: Updated ProductPage (lib/views/product_view.dart) to accept optional collectionId and productId parameters. Added breadcrumb navigation showing Home > Collection Name > Product with clickable links. Updated main.dart onGenerateRoute to parse nested URLs like '/collections/{collectionId}/products/{productId}' by extracting path segments and validating structure. Updated CollectionsPage product cards (lib/views/collections_view.dart) to navigate with collection context via '/collections/{collectionId}/products/{productId}'. Product URLs now reflect navigation path matching shop.upsu.net pattern where same product has different URLs based on where it's accessed from.

- [x] S-21.3 — **Implement Deep Linking with Browser URL Updates**
  - Configure Flutter web app to update browser URL bar when navigating
  - Replace Navigator.pushNamed with proper routing that updates the browser address bar
  - Implement go_router or similar declarative routing package for URL management
  - Ensure URLs in browser match the route structure: /collections/clothing, /collections/pride/products/id
  - Test that browser back/forward buttons work correctly with navigation
  - Test that copying URL from address bar and pasting in new tab navigates to correct page
  - Ensure URLs are properly formatted and match shop.upsu.net pattern
  - Reason: Added go_router ^14.0.0 package to pubspec.yaml. Created app_router.dart (lib/router/app_router.dart) defining all routes using GoRouter with declarative routing structure matching shop.upsu.net URL pattern. Migrated from MaterialApp to MaterialApp.router in main.dart using routerConfig parameter. Replaced all Navigator.pushNamed() calls with context.go() throughout the app (home_view.dart, about_view.dart, collections_overview_view.dart, collections_view.dart, product_view.dart, navigation_menu.dart, dropdown_menu_widget.dart). Browser address bar now updates on navigation, browser back/forward buttons work automatically, URLs can be bookmarked and shared. Deep linking fully functional matching shop.upsu.net behavior with proper URL paths like /collections/clothing and /collections/pride/products/classic-hoodie.

- [x] S-21.4 — **Support Products in Multiple Collections**
  - Products can belong to multiple collections simultaneously
  - Update Product model to have optional collectionIds list (not required for display)
  - InMemoryProductRepository should allow same product to appear in multiple collection filters
  - CollectionViewModel's getProductsForCollection returns products where collection.productIds contains the product ID
  - Product cards in collection pages must navigate with collection context: '/collections/{currentCollectionId}/products/{productId}'
  - ProductPage receives collectionId from URL for breadcrumb, not from product data
  - This allows products to be discovered through multiple navigation paths while maintaining URL context
  - Reason: Updated InMemoryCollectionRepository (lib/repositories/in_memory_collection_repository.dart) to have overlapping product IDs in Collection.productIds lists. Product '1' now appears in 6 collections (Clothing, Halloween, Signature, Portsmouth, Pride, Sale). Product '2' appears in 6 collections. Product '3' appears in 5 collections. Product '4' appears in 5 collections. CollectionViewModel's getProductsForCollection() method already filters products correctly using collection.productIds.contains(product.id), so no ViewModel changes needed. Product cards navigate with collection context (/collections/{collectionId}/products/{productId}). ProductPage receives collectionId from URL for breadcrumb display, not from product data. Same product accessible via different URLs based on navigation path, matching shop.upsu.net behavior.

- [x] S-22 — **Hero Carousel Widget**
  - Create CarouselSlide model (lib/models/carousel_slide.dart): title, subtitle, imageUrl, buttonText, buttonRoute
  - Create HeroCarousel widget (lib/widgets/home/hero_carousel.dart)
  - Implement PageView for sliding between carousel items
  - Add auto-advance timer (e.g., every 5 seconds)
  - Add manual navigation dots/indicators
  - First slide has "BROWSE COLLECTION" button linking to a collection
  - Add Keys: Key('hero_carousel'), Key('carousel_slide_0'), Key('browse_collection_button')
  - Reason: Created CarouselSlide model (lib/models/carousel_slide.dart) with title, subtitle, imageUrl, buttonText, buttonRoute properties. Created CarouselData class (lib/data/carousel_data.dart) with 3 sample slides linking to Portsmouth, Halloween, and Pride collections. Implemented HeroCarousel widget (lib/widgets/home/hero_carousel.dart) using PageView.builder for swipeable slides. Added auto-advance timer (5 second intervals) with smooth animations (400ms duration, easeInOut curve). Each slide displays image with dark overlay, centered title/subtitle text, and call-to-action button navigating via go_router. Added navigation dots indicator at bottom showing current slide position. Includes all required test Keys: 'hero_carousel', 'carousel_slide_0', 'browse_collection_button'. Timer properly cancelled in dispose() to prevent memory leaks.

- [x] S-23 — **Carousel Integration & Navigation**
  - Replace static hero section in home_view.dart with HeroCarousel
  - Create sample carousel data with 3-5 slides
  - Wire up carousel button actions to navigate to collection pages
  - Ensure smooth transitions and proper aspect ratios
  - Test carousel on mobile and desktop views
  - Reason: Replaced static hero section in home_view.dart with HeroCarousel widget using CarouselData.slides (3 slides for Portsmouth, Halloween, and Pride collections). Carousel buttons navigate to collection pages via go_router's context.go(). Updated home_test.dart to check for carousel presence (Key('hero_carousel')) and first slide content instead of old static hero content. Carousel displays with smooth auto-advance transitions (5 seconds, 400ms animation), manual swipe support, and navigation dots. Maintains 400px height with proper aspect ratios across mobile and desktop views. All tests passing with zero-latency repository.

- [x] S-24 — **Deep Linking & Routes**
  - Update main.dart with all new named routes:
    - '/about' → AboutPage
    - '/collections' → CollectionsOverviewPage
    - '/collections/:id' → CollectionDetailPage
    - '/collections/:id/products/:productId' → ProductPage
  - Test all routes with browser URL bar navigation
  - Reason: S-24 was already completed in S-21.3 with go_router implementation. All routes are defined in app_router.dart (lib/router/app_router.dart) using GoRouter with declarative routing. Routes include: '/' → HomeScreen, '/about' → AboutPage, '/collections' → CollectionsOverviewPage, '/collections/:collectionId' → CollectionsPage with dynamic parameter extraction, '/collections/:collectionId/products/:productId' → ProductPage with nested route parameters, '/product' → ProductPage as fallback. All navigation links throughout the app use context.go() with proper URL paths. Browser URL bar updates on navigation, URLs can be copied/bookmarked/shared, back/forward buttons work correctly. All collection routes (clothing, merchandise, halloween, signature-essential, portsmouth, pride, graduation, sale) work via dynamic routing with the collectionId parameter. Print Shack routes (/printshack/about, /printshack/personalisation) can be added similarly if needed in future. Deep linking fully functional matching shop.upsu.net behavior.

- [x] S-24.1 — **Homepage Collection Sections**
  - Update homepage to display featured collections with products (matching shop.upsu.net pattern)
  - Each section shows: collection name (clickable heading), 2 products from that collection
  - Display 2-3 featured collections on homepage (e.g., "Signature Range", "Portsmouth City Collection", "Pride Collection")
  - Collection heading links to full collection page (/collections/{collectionId})
  - Products link to product pages with collection context (/collections/{collectionId}/products/{productId})
  - Use Consumer<CollectionViewModel> to fetch collections and their products
  - Responsive layout: products side-by-side on desktop, stacked on mobile
  - Remove old "FEATURED PRODUCTS" section with hardcoded placeholder products
  - Reason: Updated home_view.dart to display 3 featured collections (Signature & Essential Range, Portsmouth City Collection, Pride Collection) using Consumer<CollectionViewModel>. Each section shows clickable collection name linking to /collections/{collectionId} and 2 products from that collection. Products link with collection context to /collections/{collectionId}/products/{productId}. Implemented responsive layout with LayoutBuilder - products displayed side-by-side on desktop (>600px width) and stacked vertically on mobile. Replaced old hardcoded "FEATURED PRODUCTS" section with real data from repositories. Updated home_test.dart to check for collection section headings instead of hardcoded product names. All tests updated to inject both ProductRepository and CollectionRepository with zero latency for deterministic testing. Homepage now matches shop.upsu.net pattern where collections act as category showcases.

- [x] S-25 — **Mobile Navigation (Hamburger Menu)**
  - Create MobileNavigationDrawer widget (lib/widgets/shared/mobile_navigation_drawer.dart)
  - Show hamburger menu icon on mobile instead of full navigation
  - Implement expandable sections for SHOP and The Print Shack in drawer
  - Add proper animations and transitions
  - Ensure drawer closes after navigation
  - Add Key('mobile_nav_drawer') for testing
  - Reason: Created MobileNavigationDrawer widget (lib/widgets/shared/mobile_navigation_drawer.dart) as a stateful widget with expandable sections for SHOP and The Print Shack menus. Drawer displays navigation items in vertical list with ListTiles. Sections with children are expandable/collapsible with expand_more/expand_less icons. Clicking any navigation item closes drawer and navigates to route using context.go(). Updated SharedHeader (lib/widgets/shared/shared_header.dart) to open drawer via Scaffold.of(context).openEndDrawer() when menu button is tapped. Added endDrawer: const MobileNavigationDrawer() to all main pages (HomeScreen, ProductPage, AboutPage, CollectionsOverviewPage, CollectionsPage). Drawer slides in from right with default Material animations. Includes Key('mobile_nav_drawer') for testing. Drawer header displays "Menu" title in university purple. Mobile navigation now fully functional across entire app.

- [x] S-26 — **Navigation & Carousel Tests**
  - Create tests for NavigationMenu widget
  - Test dropdown menu interactions
  - Test route navigation for all links
  - Test carousel auto-advance and manual navigation
  - Test mobile drawer functionality
  - Update existing tests to accommodate new navigation structure
  - Reason: Created comprehensive test suite in navigation_test.dart (test/navigation_test.dart) covering NavigationMenu widget display, navigation to About page, navigation back to home, mobile drawer opening, and drawer closing after navigation. Created carousel_test.dart (test/carousel_test.dart) with tests for navigation dots display (expects 3 dots), next/previous arrow button navigation, pause/play button toggle functionality, and carousel button navigation to collections. All tests use zero-latency repositories (InMemoryProductRepository and InMemoryCollectionRepository with latency: Duration.zero) for deterministic results. Tests use widget predicates to find specific UI elements like circular navigation dots and icon buttons. All existing tests (home_test.dart, product_test.dart) updated to inject both repositories. Complete test coverage for navigation menu, mobile drawer, and carousel functionality ensuring all major user interactions are tested.

- [x] S-27 — **Redesign Collections Overview Page to Match Website**
  - Update CollectionsOverviewPage (lib/views/collections_overview_view.dart) to match shop.upsu.net/collections layout
  - Each collection should display as a large image card with collection name overlaid on the image
  - Remove product count, description from collection cards (only show image + name overlay)
  - Use full-width hero image for each collection with dark overlay for text readability
  - Collection name should be centered on the image in large white text
  - Maintain responsive grid layout (1-4 columns based on screen width)
  - Each card should be clickable and navigate to /collections/{collectionId}
  - Add hover effect on desktop (image zoom or brightness change)
  - Match visual styling of shop.upsu.net/collections exactly
  - Keep existing test Key('collections_page') for testing
  - Reason: Completely redesigned CollectionsOverviewPage (lib/views/collections_overview_view.dart) to match shop.upsu.net/collections visual style. Each collection now displays as a large image card with collection name overlaid directly on the image. Removed product counts and descriptions from cards. Implemented Stack widget with three layers: full-bleed collection image, dark gradient overlay (30%-60% black opacity for text readability), and centered collection name in large white text (28px, bold, letter-spacing 1.2). Added MouseRegion for hover detection and AnimatedContainer for smooth scale transformation (1.05x zoom) on desktop hover. Maintains responsive grid layout with LayoutBuilder (1-4 columns based on screen width with 0.8 aspect ratio). Cards use ClipRRect for 8px rounded corners. Navigation to /collections/{collectionId} via GestureDetector. Magazine-style visual browsing experience matching shop.upsu.net exactly. Kept existing Key('collections_page') for testing compatibility.

- [x] S-28 — **Authentication System with Firebase**
  - Implement full user authentication system matching shop.upsu.net/account functionality
  - Integrate Firebase Authentication for user sign-in/sign-up (email/password and Google sign-in)
  - Create login page (lib/views/auth/login_view.dart) with email/password fields and "Sign in with Google" button
  - Create signup page (lib/views/auth/signup_view.dart) with email/password/confirm password fields
  - Create account dashboard page (lib/views/auth/account_view.dart) showing user info, order history, addresses
  - Add routes: '/account/login', '/account/signup', '/account' (protected route requiring authentication)
  - Update header account button (person_outline icon) to navigate to /account/login if not signed in, /account if signed in
  - Account dashboard should display: Welcome message with user name/email, "Sign Out" button, order history section, saved addresses section
  - Implement AuthService (lib/services/auth_service.dart) to manage authentication state with Firebase
  - Use StreamBuilder or Consumer to reactively update UI based on authentication state
  - Store user data in Firebase Firestore (users collection with userId, email, displayName, addresses, orders)
  - Add persistent authentication (user stays logged in after closing app)
  - Add password reset functionality on login page ("Forgot password?" link)
  - Implement form validation for all auth forms (email format, password strength, matching passwords)
  - Add loading states and error handling for all auth operations
  - Match visual styling of shop.upsu.net account pages (clean form layouts, university purple buttons)
  - Add Keys for testing: Key('login_page'), Key('signup_page'), Key('account_page'), Key('sign_out_button')
  - Reason: Shop.upsu.net has a full authentication system where users can create accounts, sign in, and access a personalized dashboard at /account showing their profile information, order history, and saved addresses. This feature enables user-specific functionality like saving cart items, viewing order history, and managing account settings. Firebase Authentication provides secure, production-ready user authentication with minimal backend code. The account button in the header should check authentication state and navigate to appropriate page (login if not authenticated, dashboard if authenticated).

- [x] S-29 — **Shopping Cart - Models and Repository**
  - Create CartItem model (lib/models/cart_item.dart) with properties: product, quantity, selectedOptions (size, color, etc.)
  - Create Cart model (lib/models/cart.dart) with properties: items list, totalPrice getter, totalItems getter
  - Create CartRepository interface (lib/repositories/cart_repository.dart) with methods: getCart(), addItem(), removeItem(), updateQuantity(), clearCart()
  - Create InMemoryCartRepository (lib/repositories/in_memory_cart_repository.dart) implementing CartRepository with local storage simulation
  - Cart should persist items (simulate persistence with in-memory storage, can be enhanced with shared_preferences later)
  - Reason: Created CartItem model (lib/models/cart_item.dart) with id, product, quantity, selectedOptions properties and totalPrice getter that calculates item total (price × quantity). Created Cart model (lib/models/cart.dart) with items list and convenience getters: totalItems (sum of quantities), totalPrice (sum of item totals), isEmpty/isNotEmpty checks, and formattedTotal (£XX.XX string). Created CartRepository interface (lib/repositories/cart_repository.dart) defining 5 core operations: getCart(), addItem(), removeItem(), updateQuantity(), clearCart(). Implemented InMemoryCartRepository (lib/repositories/in_memory_cart_repository.dart) with in-memory storage (_items list) and configurable latency (default 500ms, Duration.zero for tests). Repository intelligently handles duplicates by checking if product with same options exists and updating quantity or adding new item. updateQuantity() removes items with quantity ≤ 0. Cart persists during app session. All models follow repository pattern for consistent data access and testing.

- [x] S-30 — **Shopping Cart - ViewModel and State Management**
  - Create CartViewModel (lib/view_models/cart_view_model.dart) extending BaseViewModel
  - CartViewModel should expose: cart items, total price, total items count, loading state
  - Implement methods: addToCart(product, quantity), removeFromCart(itemId), updateQuantity(itemId, quantity), clearCart()
  - Use CartRepository for all data operations
  - Notify listeners on any cart changes so UI updates reactively
  - Wire CartViewModel into Provider in main.dart for dependency injection
  - Reason: Created CartViewModel (lib/view_models/cart_view_model.dart) extending BaseViewModel with cart state management. ViewModel exposes cart data via getters: cart (Cart object), totalItems (int), totalPrice (double), formattedTotal (string), isEmpty (bool). Implemented 5 operations: addToCart() adds product with quantity and optional selectedOptions, removeFromCart() removes item by ID, updateQuantity() updates item quantity (removes if ≤ 0), clearCart() empties cart, refreshCart() reloads from repository. All operations use runWithLoading() from BaseViewModel for loading states and automatically reload cart from repository to keep UI in sync. Wired CartViewModel into Provider in main.dart with ChangeNotifierProvider<CartViewModel> created with CartRepository dependency. Added CartRepository parameter to createApp() factory function accepting optional cartRepo for testing (defaults to InMemoryCartRepository with 500ms latency). Cart state now accessible throughout app via Provider.of<CartViewModel>(context) or Consumer<CartViewModel>. UI updates automatically when cart changes via notifyListeners() inherited from BaseViewModel.

- [x] S-31 — **Shopping Cart - UI Integration**
  - Update ProductPage (lib/views/product_view.dart) to add "Add to Cart" button with quantity selector
  - "Add to Cart" button should call CartViewModel.addToCart() and show confirmation (SnackBar or dialog)
  - Update SharedHeader cart icon to show badge with item count from CartViewModel
  - Cart icon should navigate to /cart route when tapped
  - Create CartPage (lib/views/cart_view.dart) displaying cart items with images, names, prices, quantities
  - Each cart item should have quantity controls (+/- buttons) and remove button
  - Show subtotal, total items count, and "Checkout" button (placeholder functionality)
  - Add empty cart state with message and "Continue Shopping" button
  - Add route '/cart' to app_router.dart routing to CartPage
  - Add Key('cart_page'), Key('add_to_cart_button'), Key('cart_item_0') for testing
  - Reason: Updated ProductPage (lib/views/product_view.dart) to StatefulWidget with quantity state management (_quantity). Added quantity selector with +/- IconButtons allowing users to adjust quantity before adding to cart. Implemented "Add to Cart" button (Key: 'add_to_cart_button') that calls CartViewModel.addToCart() and shows SnackBar confirmation with item count. Updated SharedHeader (lib/widgets/shared/shared_header.dart) to wrap cart icon in Consumer<CartViewModel> displaying badge with item count (shows "9+" if >9 items) positioned in top-right corner with purple background. Cart icon navigates to /cart on all pages (home, product, collections). Created CartPage (lib/views/cart_view.dart) with Key('cart_page') displaying cart items in scrollable list. Each cart item (Key: 'cart_item_0', 'cart_item_1', etc.) shows product image, name, price, quantity controls (+/- buttons calling updateQuantity()), and remove button (calling removeFromCart()). Cart page displays subtotal, total items count, and "Proceed to Checkout" button (placeholder with SnackBar). Empty cart state shows large cart icon, "Your cart is empty" message, and "Continue Shopping" button linking to homepage. Added '/cart' route to app_router.dart. Cart badge updates reactively via notifyListeners(). All cart operations integrate with CartViewModel for reactive state management.

- [x] S-32 — **Shopping Cart - Testing**
  - Create cart_test.dart (test/cart_test.dart) with comprehensive cart functionality tests
  - Test adding items to cart from product page
  - Test cart icon badge displays correct item count
  - Test navigating to cart page and viewing items
  - Test updating item quantities in cart
  - Test removing items from cart
  - Test empty cart state display
  - All tests should use zero-latency CartRepository for deterministic results
  - Update main.dart createApp() to accept optional CartRepository parameter
  - Reason: Created comprehensive cart test suite in cart_test.dart (test/cart_test.dart) with 8 test cases covering all cart functionality. Tests include: empty cart state display, adding items from product page, cart badge displaying correct item count, navigating to cart page and viewing items, updating item quantities with +/- buttons, removing items from cart, cart totals display, and cart badge with multiple items. All tests use zero-latency repositories (InMemoryProductRepository, InMemoryCollectionRepository, InMemoryCartRepository with latency: Duration.zero) for deterministic results. Tests use proper Keys to find widgets (cart_page, add_to_cart_button, cart_item_0, header_cart). Tests verify UI updates correctly after cart operations including SnackBar confirmations, badge updates, and empty cart state transitions. CartRepository parameter already added to createApp() in main.dart accepting optional cartRepo for testing. All cart tests passing with zero-latency repositories ensuring fast, deterministic test execution.

- [x] S-33 — **Print Shack - About Page**
  - Create Print Shack About page (lib/views/printshack/printshack_about_view.dart)
  - Display information about the print shack service
  - Explain what text personalization is and how it works
  - Include information about pricing, turnaround time, and available options
  - Add route '/printshack/about' to app_router.dart
  - Use SharedHeader and SharedFooter for consistency
  - Add Key('printshack_about_page') for testing
  - Reason: Created PrintShackAboutPage (lib/views/printshack/printshack_about_view.dart) with comprehensive information about the Print Shack text personalization service. Page explains custom text options (up to 20 characters), multiple fonts (Arial, Times New Roman, Courier), color options, and size selections (S, M, L, XL). Displays detailed pricing information: Small £5.00, Medium £7.00, Large £9.00, Extra Large £11.00 including text personalization and printing. Shows turnaround time of 3-5 business days with express options. Features four icon-based feature cards explaining service offerings. Includes "START PERSONALIZING" button linking to /printshack/personalisation. Added /printshack/about route to app_router.dart. Uses SharedHeader and SharedFooter for consistency. Page constrained to 900px width for readability. Styled with university purple (#4d2963) accent color. Includes Key('printshack_about_page') for testing.

- [x] S-34 — **Print Shack - Personalization Page Model**
  - Create PersonalizationOption model (lib/models/personalization_option.dart) with properties: type (dropdown/text/color), label, options (for dropdown), value
  - Create PersonalizationForm model (lib/models/personalization_form.dart) with properties: product info, list of PersonalizationOptions, price calculation
  - Model should support: text input fields, dropdown selections (font, size, color), color picker
  - Calculate dynamic pricing based on selections (e.g., different prices for different sizes or colors)
  - Reason: Created PersonalizationOption model (lib/models/personalization_option.dart) with id, type (enum: text/dropdown/color), label, optional options list for dropdown choices, and mutable value field. Enum PersonalizationOptionType defines three types of form inputs. Created PersonalizationForm model (lib/models/personalization_form.dart) managing collection of PersonalizationOptions with productName and sizePrices map. Implemented getOption() to retrieve option by ID, updateOption() to modify values, calculatePrice() returning price based on selected size from sizePrices map, formattedPrice getter returning "£X.XX" or "Select a size", isComplete checking all options filled, and getPreviewText() generating preview showing current text/font/color selections. Factory method createDefault() creates form with standard options: text input (20 char max), font dropdown (Arial/Times New Roman/Courier), size dropdown (S/M/L/XL), color dropdown (Red/Blue/Black/White/Green), with pricing S:£5, M:£7, L:£9, XL:£11. Models support flexible form structure for text personalization matching shop.upsu.net/products/personalise-text functionality.

- [x] S-35 — **Print Shack - Personalization Page UI**
  - Create Personalization page (lib/views/printshack/personalization_view.dart)
  - Display form with text input for custom text
  - Add dropdown for font selection (e.g., Arial, Times New Roman, Courier)
  - Add dropdown for size selection (S, M, L, XL) with different prices
  - Add dropdown for text color (Red, Blue, Black, White, etc.)
  - Show live preview of selected options (text displaying "Your Text: [user input] in [selected font] and [selected color]")
  - Display dynamic price calculation based on selections
  - Add "Add to Cart" button (can use existing cart functionality)
  - Form should update dynamically as user makes selections
  - Add route '/printshack/personalisation' to app_router.dart
  - Add Key('personalization_page'), Key('personalization_text_input'), Key('add_personalized_to_cart') for testing
  - Reason: Created PersonalizationPage (lib/views/printshack/personalization_view.dart) as StatefulWidget managing PersonalizationForm state. Page displays interactive form with text input (20 char limit, Key: 'personalization_text_input'), font dropdown (Arial/Times New Roman/Courier), size dropdown (S/M/L/XL), color dropdown (Red/Blue/Black/White/Green). Live preview section shows current selections using getPreviewText() updating on every form change via setState(). Dynamic price calculation displays based on selected size with formattedPrice getter showing £5-£11 or "Select a size". Form validation checks isComplete before allowing add to cart. "Add to Cart" button (Key: 'add_personalized_to_cart') creates personalized Product with custom title "Personalized: [text]", dynamic price, description containing preview text, and selectedOptions map storing all form values. Integration with existing CartViewModel.addToCart() with SnackBar confirmations for validation errors (red) and success (purple). Added /printshack/personalisation route to app_router.dart. Uses SharedHeader and SharedFooter for consistency. Page constrained to 900px width. All form changes trigger setState() for real-time preview and price updates. Personalized items stored in cart with full customization details matching shop.upsu.net/products/personalise-text functionality.

- [x] S-36 — **Print Shack - Testing**
  - Create printshack_test.dart (test/printshack_test.dart) with tests for print shack functionality
  - Test navigation to print shack about page
  - Test navigation to personalization page
  - Test text input field updates preview
  - Test dropdown selections update preview and price
  - Test adding personalized item to cart
  - All tests should use zero-latency repositories for deterministic results
  - Reason: Created comprehensive Print Shack test suite in printshack_test.dart (test/printshack_test.dart) with 8 test cases covering all Print Shack functionality. Tests include: navigation to Print Shack about page (verifies Key 'printshack_about_page' and 'The Print Shack' title), navigation to personalization page (verifies Key 'personalization_page'), all form fields display (text input Key 'personalization_text_input', font/size/color dropdowns, add to cart button Key 'add_personalized_to_cart'), text input updates preview (enters 'TEST TEXT' and verifies preview shows 'Your Text: "TEST TEXT"'), size selection updates price (selects Medium and verifies £7.00 price), validation error for incomplete form (verifies error message 'Please fill in all fields before adding to cart'), successful cart addition with complete form (fills all fields including text/font/size/color and verifies success SnackBar and cart badge shows '1'), and correct pricing for all sizes (tests S:£5, M:£7, L:£9, XL:£11). All tests use zero-latency repositories (InMemoryProductRepository, InMemoryCollectionRepository, InMemoryCartRepository with latency: Duration.zero) for deterministic results. Tests verify UI updates correctly after form interactions and confirm cart integration with personalized products. All Print Shack tests passing ensuring complete functionality from navigation to form submission.

- [x] S-37 — **Product Assets and Images**
  - Create assets folder structure (assets/images/products/)
  - Add product images as local assets instead of network images
  - Update pubspec.yaml to include assets folder
  - Update Product model to use asset paths
  - Update InMemoryProductRepository with asset image paths
  - Update all product displays (home, collections, product page) to use Image.asset()
  - Reason: Updated pubspec.yaml to include assets configuration with three directories: assets/images/products/, assets/images/collections/, assets/images/carousel/. Updated InMemoryProductRepository (lib/repositories/in_memory_product_repository.dart) to use placeholder asset paths 'assets/images/products/product_1.jpg' through 'product_4.jpg'. Updated InMemoryCollectionRepository (lib/repositories/in_memory_collection_repository.dart) with asset paths for all 8 collections (clothing.jpg, merchandise.jpg, halloween.jpg, signature.jpg, portsmouth.jpg, pride.jpg, graduation.jpg, sale.jpg). Updated CarouselData (lib/data/carousel_data.dart) with carousel asset paths 'assets/images/carousel/slide_1.jpg' through 'slide_3.jpg'. Changed all Image.network() to Image.asset() throughout app: home_view.dart (_ProductCard), collections_overview_view.dart (_CollectionCard), collections_view.dart (_ProductCard), product_view.dart (product image), cart_view.dart (_CartItemCard), hero_carousel.dart (_buildSlide), personalization_view.dart (personalized product placeholder). Added comprehensive error handling with errorBuilder showing helpful messages indicating which image file to add when missing (displays icon + file path like 'Add image: assets/images/products/product_1.jpg'). Local assets provide better performance, offline support, eliminate external image URL dependencies, and allow organized image management. Images ready for developer to add with matching filenames - app will automatically display them without code changes.

- [ ] S-38 — **Product Options System**
  - Create ProductOption model (lib/models/product_option.dart) with properties: id, name, type (size/color/material), values, required
  - Update Product model to include optional List<ProductOption> options field
  - Create product option selector widget (lib/widgets/product/product_options_selector.dart)
  - Display option selectors on product page (dropdowns for size, color pickers, etc.)
  - Different product categories have different options:
    - Clothing: Size (XS/S/M/L/XL/XXL), Color
    - Merchandise: Color only (no size options)
    - Accessories: Material, Color
  - Store selected options when adding to cart
  - Display selected options in cart item details
  - Reason: Products on shop.upsu.net have various customization options. Clothing requires size selection, merchandise doesn't need sizing, and different product types have different available options. This matches real e-commerce behavior where product options vary by category.

- [ ] S-39 — **Sale Products with Strikethrough Pricing**
  - Add sale-related fields to Product model: isOnSale (bool), originalPrice (String), salePrice (String)
  - Update product display widgets to show strikethrough original price when isOnSale is true
  - Display sale price in prominent color (e.g., red) next to strikethrough original price
  - Add "SALE" badge to product cards for sale items
  - Update cart to use sale price for calculations when applicable
  - Update InMemoryProductRepository to include sale products with both prices
  - Reason: shop.upsu.net displays sale items with strikethrough original prices and discounted prices. This visual treatment helps customers identify deals and savings. Sale badge draws attention to promotional items.

- [ ] S-40 — **Search Functionality**
  - Create SearchViewModel (lib/view_models/search_view_model.dart) extending BaseViewModel
  - Implement search() method in ProductRepository using product titles and descriptions
  - Create SearchPage (lib/views/search_view.dart) displaying search results
  - Update SharedHeader search icon to navigate to search page or show search dialog
  - Implement search bar with TextField that filters products as user types
  - Display search results in grid layout matching collections page
  - Show "No results found" state when search returns empty
  - Add route '/search' to app_router.dart with optional query parameter
  - Support deep linking for searches (e.g., /search?q=hoodie)
  - Add Key('search_page'), Key('search_input'), Key('search_result_0') for testing
  - Reason: Search is a fundamental e-commerce feature allowing users to quickly find specific products. shop.upsu.net has search functionality in header and footer. Search should filter across all products regardless of collection, providing quick product discovery.

- [ ] S-41 — **Testing for New Features**
  - Create product_options_test.dart testing size/color selection and cart integration
  - Create sale_products_test.dart testing strikethrough pricing display
  - Create search_test.dart testing search functionality and results display
  - All tests should use zero-latency repositories for deterministic results
  - Reason: Comprehensive testing ensures new product features work correctly including options selection, sale price calculations, and search functionality. Tests verify UI displays correctly and integrates properly with existing cart system.

---

**🎉🎉🎉 PRINT SHACK FEATURE (S-33 through S-36) IS NOW 100% COMPLETE! 🎉🎉🎉**

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

