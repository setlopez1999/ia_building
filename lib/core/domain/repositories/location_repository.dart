import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/location/location.entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class LocationRepository {
  Future<Either<AppException, List<LocationEntity>>> getDepartments();
  Future<Either<AppException, List<LocationEntity>>> getProvinces(String departmentCode);
  Future<Either<AppException, List<LocationEntity>>> getDistricts(String departmentCode, String provinceCode);
}