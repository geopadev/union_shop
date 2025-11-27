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

- [ ] S-04 — Shared footer widget  
  - `lib/widgets/shared/shared_footer.dart` implemented with Key('footer_main').

- [ ] S-05 — MVVM scaffolding
  - HomeViewModel and ProductViewModel now extend a new BaseViewModel (lib/view_models/base_view_model.dart)
  - BaseViewModel centralises loading state and helpers.

- [ ] S-06 — Repositories & DI  
  - `ProductRepository` interface and `InMemoryProductRepository` implemented with configurable latency.  
  - Repositories and view models injected via Provider in `main.dart`.

- [ ] S-07 — Routing & navigation  
  - Routes and `navigatorKey` exposed in `main.dart` (home + /product route present).

- [ ] S-08 — Testability fixes
  - Tests should build the app via `createApp(productRepo: InMemoryProductRepository(latency: Duration.zero))` (see lib/main.dart).  
  - This ensures deterministic widget tests by removing artificial repo latency while keeping the production default unchanged.

- [ ] S-09 — Accessibility, theming, responsiveness
  - Added semantic labels to product images and wrapped header/footer with Semantics to improve screen reader support (lib/views/* and lib/widgets/shared/*).  
  - Header strip now keeps its original icon-only actions so the look remains unchanged while tooltips keep it accessible (lib/widgets/shared/shared_header.dart).  
  - Products grid layout now adapts columns & aspect ratio to available width to improve responsiveness (lib/views/home_view.dart).

- [ ] S-10 — Documentation
  - Added developer usage examples, test instructions and guidance for adding new views, view models and repositories below.

--- 

## Developer quickstart (how to run the app)
- Install Flutter and ensure `flutter doctor` is green.
- From repository root:
  - flutter pub get
  - flutter run -d <device>

Why: concise steps to run the app for new contributors.

## Running widget tests deterministically
- The app exposes a test hook in lib/main.dart: createApp({ProductRepository? productRepo, GlobalKey<NavigatorState>? navigatorKey}).
- Example widget test setup:
  - final repo = InMemoryProductRepository(latency: Duration.zero);
  - await tester.pumpWidget(createApp(productRepo: repo));
  - await tester.pumpAndSettle();
- For integration tests you can also pass navigatorKey to control navigation.

Why: shows how to inject a zero-latency repository so tests are deterministic and fast.

## How to add a new View / ViewModel / Repository
1. Create files under:
   - lib/views for UI pages (Widget classes)
   - lib/view_models for ChangeNotifier view models
   - lib/repositories for repository interfaces & implementations
2. ViewModel pattern:
   - ViewModels should extend BaseViewModel (lib/view_models/base_view_model.dart) to reuse loading/notify helpers.
   - Expose immutable lists or unmodifiable snapshots for collections (use List.unmodifiable(...)).
3. Repository pattern:
   - Define an abstract interface in lib/repositories and provide one or more implementations (e.g., InMemory or network-backed).
   - Make latency configurable on in-memory implementations to make tests deterministic.
4. Registering with DI:
   - Register repository and view models in main.dart (createApp factory) using Provider / ChangeNotifierProvider.
   - Example:
     - Provider<ProductRepository>.value(value: myRepo),
     - ChangeNotifierProvider<MyViewModel>(create: (_) => MyViewModel(myRepo)),

Why: provides a consistent recipe for adding features that fits the existing MVVM + DI architecture.

## Test tips & keys
- Use Keys added to widgets for robust tests:
  - Header/logo: Key('logoTap'), Key('app_logo')
  - Search/Cart/Menu icon keys: Key('header_Search'), Key('header_Cart'), Key('header_menu')
  - Hero and product keys: Key('hero_title'), Key('browse_products_button'), Key('products_section_title'), Key('product_card_{id}')
  - Footer: Key('footer_main')
- When asserting UI state after async loads, use:
  - await tester.pump(); // start frame
  - await tester.pumpAndSettle(); // wait for animations/streams/futures

Why: lists the canonical Keys and test workflow to reduce flakiness.

## Where to document further
- Add project-specific recipes (e.g., API auth, mocking network calls) into README.md or docs/ when available.

Why: encourages expanding documentation beyond this file.

---

## 4. Feature: Homepage (Basic & Responsive)
**Description:** Implement the static homepage with a "Hero" banner and a responsive product grid. This corresponds to the "Basic" (Static Homepage) and "Intermediate" (Responsiveness) marking criteria.

**User Stories:**
- User: I want to see a promotional banner so I know about current sales.
- User: I want to view a list of products in a grid.
- User (Mobile): I want a single-column layout for easy scrolling.
- User (Desktop): I want a multi-column layout (3-4 items) to use screen space effectively.

**Acceptance Criteria:**
- Hero section displays text: "BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!"
- Product grid adapts columns based on screen width (Responsive).
- Data is fetched via `HomeViewModel` (lib/view_models/home_view_model.dart).
- UI elements have specific Keys for testing (`hero_section`, `products_grid`).

### Subtasks (Feature 4)
- [x] S-11 — **HomeViewModel Logic**: Create/verify `HomeViewModel` (lib/view_models/home_view_model.dart) extending `BaseViewModel`. Inject `ProductRepository` and implement the logic to fetch products into an unmodifiable list.
- [x] S-12 — **HomeView Skeleton**: Implement `lib/views/home_view.dart` Scaffold using `SharedHeader` and `SharedFooter`.
- [x] S-13 — **Hero Section UI**: Implement the purple banner with the specific sale text and "Browse Products" button. Assign `Key('hero_section')`.
- [x] S-14 — **Responsive Grid Layout**: Implement the grid structure (SliverGrid or LayoutBuilder) that changes column count based on width (use dummy cards initially).
- [x] S-15 — **Data Integration**: Connect `HomeView` to `HomeViewModel` via Provider and replace dummy cards with repository data.

---

complete: Feature 4 (Homepage - Basic & Responsive)

---

## 5. Feature: Product Details Page

**Description:** Implement a product details page that displays individual product information when a user taps on a product card from the homepage. This page should show the product image, title, price, and an "Add to cart" button.

**User Stories:**
- User: I want to tap on a product card to see more details about that product.
- User: I want to see a large product image, title, and price on the details page.
- User: I want an "Add to cart" button so I can add the product to my cart (placeholder functionality).
- User (Mobile): I want the header to scroll with the content so I have more screen space for product details.

**Acceptance Criteria:**
- Product page displays when navigating to `/product` route with product ID as argument.
- Page shows product image (300px height), title, price, and "Add to cart" button.
- Data is fetched via `ProductViewModel` using `ProductRepository.fetchById()`.