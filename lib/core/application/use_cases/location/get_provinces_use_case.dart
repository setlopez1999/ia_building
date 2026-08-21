import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/location/location.entity.dart';
import 'package:tvapp/core/domain/repositories/location_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetProvincesUseCase{
  GetProvincesUseCase(this._locationRepository);

  final LocationRepository _locationRepository;

   Future<Either<AppException, List<LocationEntity>>> execute(String provinceCode) {
    return _locationRepository.getProvinces(provinceCode);
  }
}