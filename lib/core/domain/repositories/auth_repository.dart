import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/contact/contact_entity.dart';
import 'package:tvapp/core/domain/entities/login_info/login_info_entity.dart';
import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class AuthRepository {
  Future<Either<AppException, User>> login(String email, String password);
  Future<Either<AppException, User>> loginWithToken(String token);
  Future<Either<AppException, Contact>> getAuthInfo();
  Future<Either<AppException, bool>> saveSensitiveData(SensitiveDataEntity sensitiveDataEntity);
  Future<Either<AppException, SensitiveDataEntity>> getSensitiveData();
  Future<void> cleanSession();
  Future<Either<AppException, void>> register({
    required Settings settings,
    required RegisterUserDto params,
    required String departmentCode,
    required String provinceCode,
    required String districtCode,
    required bool acceptTerms,
    required bool acceptPolicies
  });
}