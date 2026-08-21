import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class LoginTokenUseCase {
  LoginTokenUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AppException, User>> execute(String token) async {
    return _authRepository.loginWithToken(token);
  }
}
