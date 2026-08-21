import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetSessionUseCase {
  GetSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AppException, SensitiveDataEntity>> execute() async {
    return _authRepository.getSensitiveData();
  }
}
