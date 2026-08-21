import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class GuideRepository {
  Future<Either<AppException, List<Channel>>> getGuide(String email);
}