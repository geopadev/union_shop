import 'package:union_shop/models/product.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/view_models/base_view_model.dart';

/// ViewModel for the Search screen
/// Manages search query and results
class SearchViewModel extends BaseViewModel {
  final ProductRepository _repository;
  List<Product> _searchResults = [];
  String _currentQuery = '';

  /// Current search results
  List<Product> get searchResults => List.unmodifiable(_searchResults);

  /// Current search query
  String get currentQuery => _currentQuery;

  /// Whether search has been performed
  bool get hasSearched => _currentQuery.isNotEmpty;

  /// Whether no results were found
  bool get noResults => hasSearched && _searchResults.isEmpty;

  SearchViewModel(this._repository);

  /// Perform search with given query
  Future<void> search(String query) async {
    _currentQuery = query.trim();

    if (_currentQuery.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    await runWithLoading(() async {
      _searchResults = await _repository.search(_currentQuery);
    });
  }

  /// Clear search results and query
  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    notifyListeners();
  }
}
