import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/home_view_model.dart';

import '../helpers/mock_annotations.mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('HomeViewModel Tests', () {
    late MockProductRepository mockRepository;
    late List<Product> testProducts;

    setUp(() {
      mockRepository = MockProductRepository();
      testProducts = [
        TestHelpers.createTestProduct(
            id: 'prod1', title: 'Product 1', price: '£20.00'),
        TestHelpers.createTestProduct(
            id: 'prod2', title: 'Product 2', price: '£25.00'),
        TestHelpers.createTestProduct(
            id: 'prod3', title: 'Product 3', price: '£30.00'),
      ];
    });

    group('Initialization', () {
      test('should load products on initialization', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);

        // Act
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.products.length, 3);
        verify(mockRepository.fetchAll()).called(1);
      });

      test('should start with empty products list', () {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProducts));

        // Act
        final viewModel = HomeViewModel(mockRepository);

        // Assert - check before async load completes
        expect(viewModel.products.isEmpty, true);
      });

      test('should handle empty products list', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => []);

        // Act
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.products.isEmpty, true);
      });

      test('should set loading state during initialization', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProducts));

        // Act
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration(milliseconds: 10));

        // Assert
        expect(viewModel.isLoading, true);

        await Future.delayed(Duration(milliseconds: 100));
        expect(viewModel.isLoading, false);
      });
    });

    group('products Getter', () {
      test('should return unmodifiable list', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Act
        final products = viewModel.products;

        // Assert
        expect(() => products.add(TestHelpers.createTestProduct()),
            throwsUnsupportedError);
      });

      test('should return all loaded products', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.products.length, 3);
        expect(viewModel.products[0].id, 'prod1');
        expect(viewModel.products[1].id, 'prod2');
        expect(viewModel.products[2].id, 'prod3');
      });

      test('should return empty list when no products loaded', () {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProducts));

        // Act
        final viewModel = HomeViewModel(mockRepository);

        // Assert
        expect(viewModel.products.isEmpty, true);
      });
    });

    group('refreshProducts Method', () {
      test('should reload products from repository', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        clearInteractions(mockRepository);

        // Act
        await viewModel.refreshProducts();

        // Assert
        verify(mockRepository.fetchAll()).called(1);
      });

      test('should update products list after refresh', () async {
        // Arrange
        final initialProducts = [
          TestHelpers.createTestProduct(id: 'prod1', title: 'Old Product'),
        ];
        final updatedProducts = [
          TestHelpers.createTestProduct(id: 'prod1', title: 'New Product'),
          TestHelpers.createTestProduct(id: 'prod2', title: 'Another Product'),
        ];

        var callCount = 0;
        when(mockRepository.fetchAll()).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? initialProducts : updatedProducts;
        });

        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        expect(viewModel.products.length, 1);
        expect(viewModel.products[0].title, 'Old Product');

        // Act
        await viewModel.refreshProducts();

        // Assert
        expect(viewModel.products.length, 2);
        expect(viewModel.products[0].title, 'New Product');
        expect(viewModel.products[1].title, 'Another Product');
      });

      test('should set loading state during refresh', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        when(mockRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProducts));

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.refreshProducts();
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners during refresh', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.refreshProducts();

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle multiple refreshes', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Act
        await viewModel.refreshProducts();
        await viewModel.refreshProducts();
        await viewModel.refreshProducts();

        // Assert - called 4 times: 1 init + 3 refreshes
        verify(mockRepository.fetchAll()).called(4);
      });
    });

    group('Error Handling', () {
      test('should propagate error from repository on initialization',
          () async {
        // Arrange
        when(mockRepository.fetchAll()).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => HomeViewModel(mockRepository), returnsNormally);
        // Note: Error happens asynchronously in constructor
      });

      test('should propagate error from repository on refresh', () async {
        // Arrange
        when(mockRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        when(mockRepository.fetchAll())
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => viewModel.refreshProducts(), throwsException);
      });

      test('should set loading to false after error', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        when(mockRepository.fetchAll()).thenThrow(Exception('Error'));

        // Act & Assert
        expect(viewModel.isLoading, false);

        try {
          await viewModel.refreshProducts();
        } catch (_) {}

        expect(viewModel.isLoading, false);
      });
    });

    group('Complex Scenarios', () {
      test('should handle large product lists', () async {
        // Arrange
        final largeProductList = List.generate(
          100,
          (index) => TestHelpers.createTestProduct(
            id: 'prod$index',
            title: 'Product $index',
          ),
        );

        when(mockRepository.fetchAll())
            .thenAnswer((_) async => largeProductList);

        // Act
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.products.length, 100);
        expect(viewModel.products.first.id, 'prod0');
        expect(viewModel.products.last.id, 'prod99');
      });

      test('should handle refresh with different product count', () async {
        // Arrange
        final initialProducts = List.generate(
            5, (i) => TestHelpers.createTestProduct(id: 'prod$i'));
        final refreshedProducts = List.generate(
            10, (i) => TestHelpers.createTestProduct(id: 'new_prod$i'));

        var callCount = 0;
        when(mockRepository.fetchAll()).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? initialProducts : refreshedProducts;
        });

        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        expect(viewModel.products.length, 5);

        // Act
        await viewModel.refreshProducts();

        // Assert
        expect(viewModel.products.length, 10);
        expect(viewModel.products.first.id, 'new_prod0');
      });

      test('should handle refresh to empty list', () async {
        // Arrange
        var callCount = 0;
        when(mockRepository.fetchAll()).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? testProducts : [];
        });

        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        expect(viewModel.products.length, 3);

        // Act
        await viewModel.refreshProducts();

        // Assert
        expect(viewModel.products.isEmpty, true);
      });

      test('should properly dispose', () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        // Act
        viewModel.dispose();

        // Assert
        expect(viewModel.isLoading, false);
      });

      test('should handle listener notifications during init and refresh',
          () async {
        // Arrange
        when(mockRepository.fetchAll()).thenAnswer((_) async => testProducts);
        final viewModel = HomeViewModel(mockRepository);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        await Future.delayed(Duration.zero);
        final initNotifyCount = notifyCount;

        // Act
        await viewModel.refreshProducts();

        // Assert
        expect(initNotifyCount, greaterThan(0));
        expect(notifyCount, greaterThan(initNotifyCount));
      });
    });
  });
}
