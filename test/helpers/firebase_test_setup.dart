import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebasePlatform extends FirebasePlatform {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseAppPlatform();
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseAppPlatform();
  }

  @override
  List<FirebaseAppPlatform> get apps => [MockFirebaseAppPlatform()];
}

class MockFirebaseAppPlatform extends FirebaseAppPlatform {
  MockFirebaseAppPlatform() : super(defaultFirebaseAppName, _options);

  static const FirebaseOptions _options = FirebaseOptions(
    apiKey: 'fake-api-key',
    appId: 'fake-app-id',
    messagingSenderId: 'fake-sender-id',
    projectId: 'fake-project-id',
  );

  @override
  Future<void> delete() async {}

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {}
}

void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FirebasePlatform.instance = MockFirebasePlatform();
}
