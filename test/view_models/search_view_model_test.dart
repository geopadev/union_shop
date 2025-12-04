import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/view_models/search_view_model.dart';

import '../helpers/mock_annotations.mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('SearchViewModel Tests', () {
    late MockProductRepository mockRepository;
    late List<Product> testProducts;

    setUp(() {
      mockRepository = MockProductRepository();
      testProducts = [
        TestHelpers.createTestProduct(
            id: 'prod1', title: 'Red Hoodie', price: '£25.00'),
        TestHelpers.createTestProduct(
            id: 'prod2', title: 'Blue T-Shirt', price: '£15.00'),
        TestHelpers.createTestProduct(
            id: 'prod3', title: 'Red Cap', price: '£10.00'),
      ];
    });

    group('Initialization', () {
      test('should initialize with empty search results', () {
        // Act
        final viewModel = SearchViewModel(mockRepository);

        // Assert
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.currentQuery, '');
        expect(viewModel.hasSearched, false);
        expect(viewModel.noResults, false);
        expect(viewModel.isLoading, false);
      });

      test('should not call repository on initialization', () {
        // Act
        SearchViewModel(mockRepository);

        // Assert
        verifyNever(mockRepository.search(any));
      });
    });

    group('search Method', () {
      test('should call repository with query', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');

        // Assert
        verify(mockRepository.search('red')).called(1);
      });

      test('should update search results after search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');

        // Assert
        expect(viewModel.searchResults.length, 3);
        expect(viewModel.searchResults, testProducts);
      });

      test('should update currentQuery after search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');

        // Assert
        expect(viewModel.currentQuery, 'red');
      });

      test('should trim whitespace from query', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('  red  ');

        // Assert
        verify(mockRepository.search('red')).called(1);
        expect(viewModel.currentQuery, 'red');
      });

      test('should handle empty query', () async {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('');

        // Assert
        verifyNever(mockRepository.search(any));
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.currentQuery, '');
        expect(viewModel.hasSearched, false);
      });

      test('should handle whitespace-only query', () async {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('   ');

        // Assert
        verifyNever(mockRepository.search(any));
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.currentQuery, '');
      });

      test('should set loading state during search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async =>
            await Future.delayed(
                const Duration(milliseconds: 50), () => testProducts));
        final viewModel = SearchViewModel(mockRepository);

        // Act & Assert
        expect(viewModel.isLoading, false);

        final future = viewModel.search('red');
        await Future.delayed(const Duration(milliseconds: 10));
        expect(viewModel.isLoading, true);

        await future;
        expect(viewModel.isLoading, false);
      });

      test('should notify listeners after search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        await viewModel.search('red');

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle multiple searches', () async {
        // Arrange
        final redProducts = [
          TestHelpers.createTestProduct(id: 'prod1', title: 'Red Hoodie'),
          TestHelpers.createTestProduct(id: 'prod3', title: 'Red Cap'),
        ];
        final blueProducts = [
          TestHelpers.createTestProduct(id: 'prod2', title: 'Blue T-Shirt'),
        ];

        when(mockRepository.search('red')).thenAnswer((_) async => redProducts);
        when(mockRepository.search('blue'))
            .thenAnswer((_) async => blueProducts);

        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');
        expect(viewModel.searchResults.length, 2);
        expect(viewModel.currentQuery, 'red');

        await viewModel.search('blue');
        expect(viewModel.searchResults.length, 1);
        expect(viewModel.currentQuery, 'blue');

        // Assert
        verify(mockRepository.search('red')).called(1);
        verify(mockRepository.search('blue')).called(1);
      });

      test('should handle search returning empty results', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => []);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('nonexistent');

        // Assert
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.currentQuery, 'nonexistent');
        verify(mockRepository.search('nonexistent')).called(1);
      });
    });

    group('hasSearched Getter', () {
      test('should return false initially', () {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Assert
        expect(viewModel.hasSearched, false);
      });

      test('should return true after search with query', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');

        // Assert
        expect(viewModel.hasSearched, true);
      });

      test('should return false after search with empty query', () async {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('');

        // Assert
        expect(viewModel.hasSearched, false);
      });

      test('should return false after clearSearch', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');
        expect(viewModel.hasSearched, true);

        // Act
        viewModel.clearSearch();

        // Assert
        expect(viewModel.hasSearched, false);
      });
    });

    group('noResults Getter', () {
      test('should return false initially', () {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Assert
        expect(viewModel.noResults, false);
      });

      test('should return false when search has results', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');

        // Assert
        expect(viewModel.noResults, false);
      });

      test('should return true when search has no results', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => []);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('nonexistent');

        // Assert
        expect(viewModel.noResults, true);
        expect(viewModel.hasSearched, true);
        expect(viewModel.searchResults.isEmpty, true);
      });

      test('should return false before search is performed', () async {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Assert - No search performed yet
        expect(viewModel.noResults, false);
        expect(viewModel.hasSearched, false);
      });
    });

    group('searchResults Getter', () {
      test('should return unmodifiable list', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');

        // Act
        final results = viewModel.searchResults;

        // Assert
        expect(() => results.add(TestHelpers.createTestProduct()),
            throwsUnsupportedError);
      });

      test('should return empty list initially', () {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Assert
        expect(viewModel.searchResults.isEmpty, true);
      });

      test('should return search results after search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');

        // Assert
        expect(viewModel.searchResults.length, 3);
        expect(viewModel.searchResults[0].id, 'prod1');
        expect(viewModel.searchResults[1].id, 'prod2');
        expect(viewModel.searchResults[2].id, 'prod3');
      });
    });

    group('currentQuery Getter', () {
      test('should return empty string initially', () {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Assert
        expect(viewModel.currentQuery, '');
      });

      test('should return current query after search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red hoodie');

        // Assert
        expect(viewModel.currentQuery, 'red hoodie');
      });

      test('should return trimmed query', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('  red  ');

        // Assert
        expect(viewModel.currentQuery, 'red');
      });
    });

    group('clearSearch Method', () {
      test('should clear search results', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');
        expect(viewModel.searchResults.length, 3);

        // Act
        viewModel.clearSearch();

        // Assert
        expect(viewModel.searchResults.isEmpty, true);
      });

      test('should clear current query', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');
        expect(viewModel.currentQuery, 'red');

        // Act
        viewModel.clearSearch();

        // Assert
        expect(viewModel.currentQuery, '');
      });

      test('should reset hasSearched to false', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');
        expect(viewModel.hasSearched, true);

        // Act
        viewModel.clearSearch();

        // Assert
        expect(viewModel.hasSearched, false);
      });

      test('should reset noResults to false', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => []);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('nonexistent');
        expect(viewModel.noResults, true);

        // Act
        viewModel.clearSearch();

        // Assert
        expect(viewModel.noResults, false);
      });

      test('should notify listeners', () {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // Act
        viewModel.clearSearch();

        // Assert
        expect(notifyCount, 1);
      });

      test('should work when called multiple times', () {
        // Arrange
        final viewModel = SearchViewModel(mockRepository);

        // Act
        viewModel.clearSearch();
        viewModel.clearSearch();
        viewModel.clearSearch();

        // Assert
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.currentQuery, '');
        expect(viewModel.hasSearched, false);
      });
    });

    group('Error Handling', () {
      test('should propagate error from repository', () async {
        // Arrange
        when(mockRepository.search(any)).thenThrow(Exception('Network error'));
        final viewModel = SearchViewModel(mockRepository);

        // Act & Assert
        expect(() => viewModel.search('red'), throwsException);
      });

      test('should set loading to false after error', () async {
        // Arrange
        when(mockRepository.search(any)).thenThrow(Exception('Error'));
        final viewModel = SearchViewModel(mockRepository);

        // Act & Assert
        expect(viewModel.isLoading, false);

        try {
          await viewModel.search('red');
        } catch (_) {}

        expect(viewModel.isLoading, false);
      });

      test('should maintain previous results after error', () async {
        // Arrange
        when(mockRepository.search('red'))
            .thenAnswer((_) async => testProducts);
        when(mockRepository.search('blue')).thenThrow(Exception('Error'));
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');
        final previousResults = viewModel.searchResults.length;

        // Act & Assert
        try {
          await viewModel.search('blue');
        } catch (_) {}

        // Results should remain from successful search
        expect(viewModel.searchResults.length, previousResults);
      });
    });

    group('Complex Scenarios', () {
      test('should handle search, clear, search workflow', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');
        expect(viewModel.searchResults.length, 3);
        expect(viewModel.hasSearched, true);

        viewModel.clearSearch();
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.hasSearched, false);

        await viewModel.search('blue');
        expect(viewModel.hasSearched, true);

        // Assert
        verify(mockRepository.search('red')).called(1);
        verify(mockRepository.search('blue')).called(1);
      });

      test('should handle rapid consecutive searches', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('a');
        await viewModel.search('ab');
        await viewModel.search('abc');

        // Assert
        verify(mockRepository.search('a')).called(1);
        verify(mockRepository.search('ab')).called(1);
        verify(mockRepository.search('abc')).called(1);
        expect(viewModel.currentQuery, 'abc');
      });

      test('should handle empty query after successful search', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('red');
        expect(viewModel.searchResults.length, 3);

        await viewModel.search('');

        // Assert
        expect(viewModel.searchResults.isEmpty, true);
        expect(viewModel.hasSearched, false);
        verify(mockRepository.search('red')).called(1);
        // Empty search should not call repository
        verifyNever(mockRepository.search(''));
      });

      test('should properly dispose', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        await viewModel.search('red');

        // Act
        viewModel.dispose();

        // Assert
        expect(viewModel.isLoading, false);
      });

      test('should handle special characters in query', () async {
        // Arrange
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search('t-shirt & hoodie!');

        // Assert
        verify(mockRepository.search('t-shirt & hoodie!')).called(1);
        expect(viewModel.currentQuery, 't-shirt & hoodie!');
      });

      test('should handle very long query', () async {
        // Arrange
        final longQuery = 'a' * 500;
        when(mockRepository.search(any)).thenAnswer((_) async => testProducts);
        final viewModel = SearchViewModel(mockRepository);

        // Act
        await viewModel.search(longQuery);

        // Assert
        verify(mockRepository.search(longQuery)).called(1);
        expect(viewModel.currentQuery, longQuery);
      });
    });
  });
}
