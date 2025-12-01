import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// Service class for handling Firebase Authentication
/// Wraps Firebase Auth functionality with simplified API
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authStateSubscription;

  AuthService() {
    // Listen to auth state changes and notify listeners
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      print('🔔 Auth state changed: ${user?.email ?? "signed out"}');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign up with email and password
  /// Returns User if successful, throws exception on error
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      print('📝 Creating new user account: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Automatically create user document in Firestore
      if (credential.user != null) {
        await _createUserDocument(credential.user!);
      }

      print('✅ User account created successfully');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('❌ Sign up error: ${e.code}');
      throw _handleAuthException(e);
    }
  }

  /// Sign in with email and password
  /// Returns User if successful, throws exception on error
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Signing in user: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure user document exists (create if it doesn't)
      if (credential.user != null) {
        await _ensureUserDocumentExists(credential.user!);
      }

      print('✅ User signed in successfully');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('❌ Sign in error: ${e.code}');
      throw _handleAuthException(e);
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    print('👋 Signing out user');
    await _auth.signOut();
    print('✅ User signed out successfully');
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);

      // Update display name in Firestore user document too
      if (_auth.currentUser != null) {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          'displayName': displayName,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      print(
          '📝 Creating Firestore user document for: ${user.email} (${user.uid})');

      // Check if document already exists first
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        print('ℹ️ User document already exists, skipping creation');
        return;
      }

      // Create the document
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': user.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'cart': [], // Initialize empty cart
        'orders': [], // Initialize empty orders
        'addresses': [], // Initialize empty addresses
      });

      print('✅ Firestore user document created successfully for ${user.uid}');

      // Verify the document was created
      final verifyDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (verifyDoc.exists) {
        print('✅ Verified: User document exists in Firestore');
        final data = verifyDoc.data();
        print('📦 Cart initialized: ${data?['cart']}');
      } else {
        print('❌ WARNING: User document was not created properly!');
      }
    } catch (e) {
      print('❌ Error creating user document: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// Ensure user document exists (create if missing)
  Future<void> _ensureUserDocumentExists(User user) async {
    try {
      print(
          '🔍 Checking if user document exists for: ${user.email} (${user.uid})');
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        print('📝 User document missing, creating it now for: ${user.email}');
        await _createUserDocument(user);
      } else {
        print('✅ User document already exists for: ${user.email}');
        print('📦 Current cart: ${doc.data()?['cart']}');
      }
    } catch (e) {
      print('❌ Error checking/creating user document: $e');
      // Don't throw error - allow user to continue
    }
  }

  /// Handle Firebase Auth exceptions with user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password too weak (minimum 6 characters)';
      case 'email-already-in-use':
        return 'Account already exists with this email';
      case 'invalid-email':
        return 'Email address is not valid';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-disabled':
        return 'Account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Check your internet connection';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
