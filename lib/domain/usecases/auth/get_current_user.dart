import 'package:venturepoint/domain/entities/user.dart';
import 'package:venturepoint/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  AuthUser? call() {
    return repository.currentUser;
  }
}
