import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Stream<User?> get authStateChanges;
  User? get currentUser;
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('Invalid email or password. Please try again.');
      }
      if (e.code == 'invalid-email') {
        throw Exception('The email address is badly formatted.');
      }
      if (e.code == 'user-disabled') {
        throw Exception('This account has been disabled. Contact support.');
      }
      throw Exception('Failed to sign in: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      }
      if (e.code == 'invalid-email') {
        throw Exception('The email address is badly formatted.');
      }
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak. Use a stronger password.');
      }
      throw Exception('Failed to sign up: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await _googleSignIn.signIn();
      
      // If user cancelled the sign-in, googleUser will be null
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credentials for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final result = await _firebaseAuth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase authentication error: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Google sign-in error: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
