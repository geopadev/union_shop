import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/collection_view_model.dart';

import '../helpers/mock_annotations.mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CollectionViewModel Tests', () {
    late MockCollectionRepository mockCollectionRepository;
    late MockProductRepository mockProductRepository;
    late List<Collection> testCollections;
    late List<Product> testProducts;

    setUp(() {
      mockCollectionRepository = MockCollectionRepository();
      mockProductRepository = MockProductRepository();

      testCollections = [
        TestHelpers.createTestCollection(
          id: 'col1',
          name: 'Collection 1',
          productIds: ['prod1', 'prod2'],
        ),
        TestHelpers.createTestCollection(
          id: 'col2',
          name: 'Collection 2',
          productIds: ['prod2', 'prod3'],
        ),
        TestHelpers.createTestCollection(
          id: 'col3',
          name: 'Collection 3',
          productIds: ['prod1', 'prod3'],
        ),
      ];

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
      test('should load collections and products on initialization', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);

        // Act
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.allCollections.length, 3);
        verify(mockCollectionRepository.fetchAll()).called(1);
        verify(mockProductRepository.fetchAll()).called(1);
      });

      test('should start with empty collections list', () {
        // Arrange
        when(mockCollectionRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testCollections));
        when(mockProductRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testProducts));

        // Act
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);

        // Assert - check before async load completes
        expect(viewModel.allCollections.isEmpty, true);
      });

      test('should set loading state during initialization', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testCollections));
        when(mockProductRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testProducts));

        // Act
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(viewModel.isLoading, true);

        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.isLoading, false);
      });
    });

    group('allCollections Getter', () {
      test('should return unmodifiable list', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final collections = viewModel.allCollections;

        // Assert
        expect(() => collections.add(TestHelpers.createTestCollection()),
            throwsUnsupportedError);
      });

      test('should return all loaded collections', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.allCollections.length, 3);
        expect(viewModel.allCollections[0].id, 'col1');
        expect(viewModel.allCollections[1].id, 'col2');
        expect(viewModel.allCollections[2].id, 'col3');
      });
    });

    group('getCollectionById Method', () {
      test('should return collection when id exists', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final collection = viewModel.getCollectionById('col1');

        // Assert
        expect(collection, isNotNull);
        expect(collection!.id, 'col1');
        expect(collection.name, 'Collection 1');
      });

      test('should return null when id does not exist', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final collection = viewModel.getCollectionById('nonexistent');

        // Assert
        expect(collection, null);
      });

      test('should return correct collection among multiple', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final col1 = viewModel.getCollectionById('col1');
        final col2 = viewModel.getCollectionById('col2');
        final col3 = viewModel.getCollectionById('col3');

        // Assert
        expect(col1!.name, 'Collection 1');
        expect(col2!.name, 'Collection 2');
        expect(col3!.name, 'Collection 3');
      });

      test('should handle case-sensitive IDs', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final collection = viewModel.getCollectionById('COL1'); // Uppercase

        // Assert
        expect(collection, null); // Should not match 'col1'
      });
    });

    group('getProductsForCollection Method', () {
      test('should return products for collection', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act - Collection 1 has prod1 and prod2
        final products = viewModel.getProductsForCollection('col1');

        // Assert
        expect(products.length, 2);
        expect(products[0].id, 'prod1');
        expect(products[1].id, 'prod2');
      });

      test('should return empty list for nonexistent collection', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final products = viewModel.getProductsForCollection('nonexistent');

        // Assert
        expect(products.isEmpty, true);
      });

      test('should filter products correctly for each collection', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final col1Products =
            viewModel.getProductsForCollection('col1'); // prod1, prod2
        final col2Products =
            viewModel.getProductsForCollection('col2'); // prod2, prod3
        final col3Products =
            viewModel.getProductsForCollection('col3'); // prod1, prod3

        // Assert
        expect(col1Products.length, 2);
        expect(col1Products.map((p) => p.id), containsAll(['prod1', 'prod2']));

        expect(col2Products.length, 2);
        expect(col2Products.map((p) => p.id), containsAll(['prod2', 'prod3']));

        expect(col3Products.length, 2);
        expect(col3Products.map((p) => p.id), containsAll(['prod1', 'prod3']));
      });

      test('should handle collection with no products', () async {
        // Arrange
        final emptyCollection = TestHelpers.createTestCollection(
          id: 'empty',
          name: 'Empty Collection',
          productIds: [],
        );
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => [emptyCollection]);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final products = viewModel.getProductsForCollection('empty');

        // Assert
        expect(products.isEmpty, true);
      });

      test('should handle product appearing in multiple collections', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act - prod2 is in both col1 and col2
        final col1Products = viewModel.getProductsForCollection('col1');
        final col2Products = viewModel.getProductsForCollection('col2');

        // Assert
        expect(col1Products.any((p) => p.id == 'prod2'), true);
        expect(col2Products.any((p) => p.id == 'prod2'), true);
      });

      test('should handle collection with invalid product IDs', () async {
        // Arrange
        final collectionWithInvalidIds = TestHelpers.createTestCollection(
          id: 'invalid',
          name: 'Invalid Collection',
          productIds: ['prod1', 'invalid_id', 'prod2'],
        );
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => [collectionWithInvalidIds]);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        final products = viewModel.getProductsForCollection('invalid');

        // Assert - only valid products should be returned
        expect(products.length, 2);
        expect(products.map((p) => p.id), containsAll(['prod1', 'prod2']));
      });
    });

    group('refreshData Method', () {
      test('should reload collections and products', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        clearInteractions(mockCollectionRepository);
        clearInteractions(mockProductRepository);

        // Act
        await viewModel.refreshData();

        // Assert
        verify(mockCollectionRepository.fetchAll()).called(1);
        verify(mockProductRepository.fetchAll()).called(1);
      });

      test('should update collections after refresh', () async {
        // Arrange
        final initialCollections = [
          TestHelpers.createTestCollection(id: 'col1', name: 'Old Collection'),
        ];
        final updatedCollections = [
          TestHelpers.createTestCollection(id: 'col1', name: 'New Collection'),
          TestHelpers.createTestCollection(
              id: 'col2', name: 'Another Collection'),
        ];

        var callCount = 0;
        when(mockCollectionRepository.fetchAll()).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? initialCollections : updatedCollections;
        });
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);

        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        expect(viewModel.allCollections.length, 1);
        expect(viewModel.allCollections[0].name, 'Old Collection');

        // Act
        await viewModel.refreshData();

        // Assert
        expect(viewModel.allCollections.length, 2);
        expect(viewModel.allCollections[0].name, 'New Collection');
      });

      test('should set loading state during refresh', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        when(mockCollectionRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testCollections));
        when(mockProductRepository.fetchAll()).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testProducts));

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.refreshData();
        await Future.delayed(const Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners during refresh', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.refreshData();

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('Error Handling', () {
      test('should handle error from refresh', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        when(mockCollectionRepository.fetchAll())
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => viewModel.refreshData(), throwsException);
      });

      test('should set loading to false after error', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        when(mockCollectionRepository.fetchAll()).thenThrow(Exception('Error'));

        // Act & Assert
        expect(viewModel.isLoading, false);

        try {
          await viewModel.refreshData();
        } catch (_) {}

        expect(viewModel.isLoading, false);
      });
    });

    group('Complex Scenarios', () {
      test('should handle large numbers of collections and products', () async {
        // Arrange
        final largeCollections = List.generate(
          50,
          (i) => TestHelpers.createTestCollection(
            id: 'col$i',
            name: 'Collection $i',
            productIds: ['prod${i % 10}', 'prod${(i + 1) % 10}'],
          ),
        );
        final largeProducts = List.generate(
          100,
          (i) =>
              TestHelpers.createTestProduct(id: 'prod$i', title: 'Product $i'),
        );

        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => largeCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => largeProducts);

        // Act
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.allCollections.length, 50);
        final firstCollectionProducts =
            viewModel.getProductsForCollection('col0');
        expect(firstCollectionProducts.length, 2);
      });

      test('should properly dispose', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll())
            .thenAnswer((_) async => testCollections);
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Act
        viewModel.dispose();

        // Assert
        expect(viewModel.isLoading, false);
      });

      test('should handle empty collections and products lists', () async {
        // Arrange
        when(mockCollectionRepository.fetchAll()).thenAnswer((_) async => []);
        when(mockProductRepository.fetchAll()).thenAnswer((_) async => []);

        // Act
        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.allCollections.isEmpty, true);
        expect(viewModel.getProductsForCollection('any').isEmpty, true);
      });

      test('should handle refresh with different data sizes', () async {
        // Arrange
        final initial = [
          TestHelpers.createTestCollection(id: 'col1', productIds: ['prod1'])
        ];
        final updated = List.generate(
            5, (i) => TestHelpers.createTestCollection(id: 'col$i'));

        var callCount = 0;
        when(mockCollectionRepository.fetchAll()).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? initial : updated;
        });
        when(mockProductRepository.fetchAll())
            .thenAnswer((_) async => testProducts);

        final viewModel = CollectionViewModel(
            mockCollectionRepository, mockProductRepository);
        await Future.delayed(Duration.zero);

        expect(viewModel.allCollections.length, 1);

        // Act
        await viewModel.refreshData();

        // Assert
        expect(viewModel.allCollections.length, 5);
      });
    });
  });
}
