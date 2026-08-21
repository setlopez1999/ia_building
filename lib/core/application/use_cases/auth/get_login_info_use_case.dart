import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/contact/contact_entity.dart';
import 'package:tvapp/core/domain/entities/login_info/login_info_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetLoginInfoUseCase {

  GetLoginInfoUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AppException, Contact>> execute() async {
    return _authRepository.getAuthInfo();
  }
}