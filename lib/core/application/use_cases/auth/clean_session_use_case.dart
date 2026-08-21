import 'package:tvapp/core/domain/repositories/auth_repository.dart';

class CleanSessionUseCase {
  CleanSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> execute() async {
    await _authRepository.cleanSession();
  }
}
