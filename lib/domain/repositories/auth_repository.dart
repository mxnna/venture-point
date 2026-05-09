import 'package:venturepoint/domain/entities/user.dart';

abstract class AuthRepository {
  Future<AuthUser?> signInWithEmailAndPassword(String email, String password);
  Future<AuthUser?> signUpWithEmailAndPassword(String email, String password);
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Stream<AuthUser?> get authStateChanges;
  AuthUser? get currentUser;
}
