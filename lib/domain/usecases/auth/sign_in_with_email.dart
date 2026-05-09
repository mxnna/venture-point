import 'package:venturepoint/domain/entities/user.dart';
import 'package:venturepoint/domain/repositories/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository repository;

  const SignInWithEmailUseCase(this.repository);

  Future<AuthUser?> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}
