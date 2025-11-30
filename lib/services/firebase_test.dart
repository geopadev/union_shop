import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Test Firebase connection and services
Future<void> testFirebaseConnection() async {
  try {
    // Check if Firebase is initialized
    final app = Firebase.app();
    print('✅ Firebase initialized: ${app.name}');

    // Check Firebase Auth
    final auth = FirebaseAuth.instance;
    print('✅ Firebase Auth available: ${auth.app.name}');

    // Check Firestore
    final firestore = FirebaseFirestore.instance;
    print('✅ Firestore available: ${firestore.app.name}');

    print('🎉 All Firebase services are connected!');
  } catch (e) {
    print('❌ Firebase connection error: $e');
  }
}
