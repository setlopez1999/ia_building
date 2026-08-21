import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class RegisterUserUseCase {
  RegisterUserUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<Either<AppException, void>> execute({
      required Settings settings,
      required RegisterUserDto params,
      required String departmentCode,
      required String provinceCode,
      required String districtCode,
      required bool acceptTerms,
      required bool acceptPolicies
  }
      ) {
    return _authRepository.register(settings: settings, params: params, departmentCode: departmentCode, provinceCode: provinceCode, districtCode: districtCode, acceptTerms: acceptTerms, acceptPolicies: acceptPolicies);
  }
}