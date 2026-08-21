import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class LoginUseCase {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AppException, User>> execute(String email, String password) async {
    return _authRepository.login(email, password);
  }
}
