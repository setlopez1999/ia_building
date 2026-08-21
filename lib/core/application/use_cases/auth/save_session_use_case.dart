import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';

class SaveSessionUseCase {
  SaveSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> execute(SensitiveDataEntity data) {
    return _authRepository.saveSensitiveData(data);
  }
}
