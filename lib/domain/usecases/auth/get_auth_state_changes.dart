import 'package:venturepoint/domain/entities/user.dart';
import 'package:venturepoint/domain/repositories/auth_repository.dart';

class GetAuthStateChangesUseCase {
  final AuthRepository repository;

  const GetAuthStateChangesUseCase(this.repository);

  Stream<AuthUser?> call() {
    return repository.authStateChanges;
  }
}
