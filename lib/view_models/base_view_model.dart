import 'package:flutter/foundation.dart';

/// Base class for all ViewModels providing common functionality
/// like loading state management and notification helpers
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;

  /// Whether this ViewModel is currently loading data
  bool get isLoading => _isLoading;

  /// Set the loading state and notify listeners
  @protected
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Helper to run an async operation with automatic loading state management
  @protected
  Future<void> runWithLoading(Future<void> Function() operation) async {
    setLoading(true);
    try {
      await operation();
    } finally {
      setLoading(false);
    }
  }
}
