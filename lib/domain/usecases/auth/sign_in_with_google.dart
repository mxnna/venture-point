import 'package:venturepoint/domain/entities/user.dart';
import 'package:venturepoint/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  const SignInWithGoogleUseCase(this.repository);

  Future<AuthUser?> call() {
    return repository.signInWithGoogle();
  }
}
