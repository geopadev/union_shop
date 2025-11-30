import 'package:firebase_auth/firebase_auth.dart';

/// Service class that wraps Firebase Authentication
/// Provides methods for user authentication operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  /// Emits User? whenever authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign up with email and password
  /// Returns User if successful, throws FirebaseAuthException on error
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with email and password
  /// Returns User if successful, throws FirebaseAuthException on error
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email
  /// Throws FirebaseAuthException if email is not found
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    await currentUser?.updateDisplayName(displayName);
  }

  /// Send sign-in link to email (passwordless authentication)
  /// User will receive an email with a magic link to sign in
  Future<void> sendSignInLinkToEmail({required String email}) async {
    try {
      // Action code settings for email link
      final actionCodeSettings = ActionCodeSettings(
        // URL you want to redirect back to after email verification
        url: 'https://union-shop-ec1b0.web.app/account/email-auth',
        // This must be true for email link sign-in
        handleCodeInApp: true,
        // iOS settings (optional)
        iOSBundleId: 'com.example.unionShop',
        // Android settings (optional)
        androidPackageName: 'com.example.union_shop',
        // Whether to install the app if not available
        androidInstallApp: true,
        // Minimum version
        androidMinimumVersion: '12',
      );

      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Check if the given link is a sign-in with email link
  bool isSignInWithEmailLink(String link) {
    return _auth.isSignInWithEmailLink(link);
  }

  /// Complete sign-in with email link
  /// Returns User if successful, throws exception on error
  Future<User?> signInWithEmailLink({
    required String email,
    required String link,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: link,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Authentication exceptions
  /// Converts Firebase error codes to user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak (minimum 6 characters).';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication error: ${e.message ?? 'Unknown error'}';
    }
  }
}
