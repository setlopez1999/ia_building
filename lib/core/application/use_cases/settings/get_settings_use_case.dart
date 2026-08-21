import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/domain/repositories/settings_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetSettingsUseCase {
  GetSettingsUseCase(this._settingsRepository);
  final SettingsRepository _settingsRepository;

  Future<Either<AppException, Settings>> execute() {
    return _settingsRepository.getSettings();
  }
}