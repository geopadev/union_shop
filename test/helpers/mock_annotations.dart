import 'package:mockito/annotations.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/repositories/collection_repository.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/view_models/cart_view_model.dart';

/// Mock annotations for code generation
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
/// This will generate mock classes in mock_annotations.mocks.dart
@GenerateMocks([
  CartRepository,
  ProductRepository,
  CollectionRepository,
  AuthService,
  CartViewModel,
])
void main() {}
