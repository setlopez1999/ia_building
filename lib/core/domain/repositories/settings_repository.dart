import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class SettingsRepository {
  Future<Either<AppException, Settings>> getSettings();
}