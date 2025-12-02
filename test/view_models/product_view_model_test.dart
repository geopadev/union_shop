import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/product_view_model.dart';

import '../helpers/mock_annotations.mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('ProductViewModel Tests', () {
    late MockProductRepository mockRepository;
    late Product testProduct;

    setUp(() {
      mockRepository = MockProductRepository();
      testProduct = TestHelpers.createTestProduct(
        id: 'prod1',
        title: 'Test Product',
        price: '£25.00',
      );
    });

    group('Initialization', () {
      test('should initialize with null product when no productId provided',
          () {
        // Act
        final viewModel = ProductViewModel(mockRepository);

        // Assert
        expect(viewModel.product, null);
        expect(viewModel.isLoading, false);
      });

      test('should load product when productId provided in constructor',
          () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);

        // Act
        final viewModel = ProductViewModel(mockRepository, productId: 'prod1');
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.product, isNotNull);
        expect(viewModel.product!.id, 'prod1');
        verify(mockRepository.fetchById('prod1')).called(1);
      });

      test('should set product to null initially before load completes', () {
        // Arrange
        when(mockRepository.fetchById(any)).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProduct));

        // Act
        final viewModel = ProductViewModel(mockRepository, productId: 'prod1');

        // Assert - check before async load completes
        expect(viewModel.product, null);
      });
    });

    group('loadProductById Method', () {
      test('should fetch product from repository', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        // Act
        await viewModel.loadProductById('prod1');

        // Assert
        verify(mockRepository.fetchById('prod1')).called(1);
      });

      test('should update product after loading', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        expect(viewModel.product, null);

        // Act
        await viewModel.loadProductById('prod1');

        // Assert
        expect(viewModel.product, isNotNull);
        expect(viewModel.product!.id, 'prod1');
        expect(viewModel.product!.title, 'Test Product');
      });

      test('should set loading state during fetch', () async {
        // Arrange
        when(mockRepository.fetchById(any)).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProduct));
        final viewModel = ProductViewModel(mockRepository);

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.loadProductById('prod1');
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after loading', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.loadProductById('prod1');

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle loading different products', () async {
        // Arrange
        final product1 =
            TestHelpers.createTestProduct(id: 'prod1', title: 'Product 1');
        final product2 =
            TestHelpers.createTestProduct(id: 'prod2', title: 'Product 2');

        when(mockRepository.fetchById('prod1'))
            .thenAnswer((_) async => product1);
        when(mockRepository.fetchById('prod2'))
            .thenAnswer((_) async => product2);

        final viewModel = ProductViewModel(mockRepository);

        // Act
        await viewModel.loadProductById('prod1');
        expect(viewModel.product!.title, 'Product 1');

        await viewModel.loadProductById('prod2');
        expect(viewModel.product!.title, 'Product 2');

        // Assert
        verify(mockRepository.fetchById('prod1')).called(1);
        verify(mockRepository.fetchById('prod2')).called(1);
      });

      test('should handle product not found', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => throw Exception('Product not found'));
        final viewModel = ProductViewModel(mockRepository);

        // Act & Assert
        expect(() => viewModel.loadProductById('invalid-id'), throwsException);
      });
    });

    group('refreshProduct Method', () {
      test('should reload current product', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        await viewModel.loadProductById('prod1');
        clearInteractions(mockRepository);

        // Act
        await viewModel.refreshProduct();

        // Assert
        verify(mockRepository.fetchById('prod1')).called(1);
      });

      test('should update product data after refresh', () async {
        // Arrange
        final initialProduct = TestHelpers.createTestProduct(
            id: 'prod1', title: 'Old Title', price: '£20.00');
        final updatedProduct = TestHelpers.createTestProduct(
            id: 'prod1', title: 'New Title', price: '£25.00');

        var callCount = 0;
        when(mockRepository.fetchById('prod1')).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? initialProduct : updatedProduct;
        });

        final viewModel = ProductViewModel(mockRepository);

        await viewModel.loadProductById('prod1');
        expect(viewModel.product!.title, 'Old Title');

        // Act
        await viewModel.refreshProduct();

        // Assert
        expect(viewModel.product!.title, 'New Title');
        expect(viewModel.product!.price, '£25.00');
      });

      test('should do nothing if no product is loaded', () async {
        // Arrange
        final viewModel = ProductViewModel(mockRepository);

        // Act
        await viewModel.refreshProduct();

        // Assert
        verifyNever(mockRepository.fetchById(any));
        expect(viewModel.product, null);
      });

      test('should set loading state during refresh', () async {
        // Arrange
        when(mockRepository.fetchById(any)).thenAnswer((_) async =>
            await Future.delayed(
                Duration(milliseconds: 50), () => testProduct));
        final viewModel = ProductViewModel(mockRepository);

        await viewModel.loadProductById('prod1');

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.refreshProduct();
        await Future.delayed(Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners during refresh', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        await viewModel.loadProductById('prod1');

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.refreshProduct();

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('Error Handling', () {
      test('should propagate error from repository on load', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenThrow(Exception('Network error'));
        final viewModel = ProductViewModel(mockRepository);

        // Act & Assert
        expect(() => viewModel.loadProductById('prod1'), throwsException);
      });

      test('should propagate error from repository on refresh', () async {
        // Arrange
        var callCount = 0;
        when(mockRepository.fetchById(any)).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return testProduct;
          } else {
            throw Exception('Network error');
          }
        });
        final viewModel = ProductViewModel(mockRepository);

        await viewModel.loadProductById('prod1');

        // Act & Assert
        expect(() => viewModel.refreshProduct(), throwsException);
      });

      test('should set loading to false after error', () async {
        // Arrange
        when(mockRepository.fetchById(any)).thenThrow(Exception('Error'));
        final viewModel = ProductViewModel(mockRepository);

        // Act & Assert
        expect(viewModel.isLoading, false);

        try {
          await viewModel.loadProductById('prod1');
        } catch (_) {}

        expect(viewModel.isLoading, false);
      });
    });

    group('Product Getter', () {
      test('should return null when no product loaded', () {
        // Arrange
        final viewModel = ProductViewModel(mockRepository);

        // Assert
        expect(viewModel.product, null);
      });

      test('should return product after loading', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        await viewModel.loadProductById('prod1');

        // Assert
        expect(viewModel.product, isNotNull);
        expect(viewModel.product, testProduct);
      });
    });

    group('Complex Scenarios', () {
      test('should handle multiple sequential loads', () async {
        // Arrange
        final product1 =
            TestHelpers.createTestProduct(id: 'prod1', title: 'Product 1');
        final product2 =
            TestHelpers.createTestProduct(id: 'prod2', title: 'Product 2');
        final product3 =
            TestHelpers.createTestProduct(id: 'prod3', title: 'Product 3');

        when(mockRepository.fetchById('prod1'))
            .thenAnswer((_) async => product1);
        when(mockRepository.fetchById('prod2'))
            .thenAnswer((_) async => product2);
        when(mockRepository.fetchById('prod3'))
            .thenAnswer((_) async => product3);

        final viewModel = ProductViewModel(mockRepository);

        // Act
        await viewModel.loadProductById('prod1');
        expect(viewModel.product!.title, 'Product 1');

        await viewModel.loadProductById('prod2');
        expect(viewModel.product!.title, 'Product 2');

        await viewModel.loadProductById('prod3');
        expect(viewModel.product!.title, 'Product 3');

        // Assert
        verify(mockRepository.fetchById('prod1')).called(1);
        verify(mockRepository.fetchById('prod2')).called(1);
        verify(mockRepository.fetchById('prod3')).called(1);
      });

      test('should handle load then refresh workflow', () async {
        // Arrange
        when(mockRepository.fetchById(any))
            .thenAnswer((_) async => testProduct);
        final viewModel = ProductViewModel(mockRepository);

        // Act
        await viewModel.loadProductById('prod1');
        await viewModel.refreshProduct();
        await viewModel.refreshProduct();

        // Assert
        verify(mockRepository.fetchById('prod1')).called(3);
      });

      test('should properly dispose', () {
        // Arrange
        final viewModel = ProductViewModel(mockRepository);

        // Act
        viewModel.dispose();

        // Assert
        expect(viewModel.isLoading, false);
      });
    });
  });
}
