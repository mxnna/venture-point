import 'package:venturepoint/domain/entities/user.dart';
import 'package:venturepoint/domain/repositories/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository repository;

  const SignUpWithEmailUseCase(this.repository);

  Future<AuthUser?> call(String email, String password) {
    return repository.signUpWithEmailAndPassword(email, password);
  }
}
