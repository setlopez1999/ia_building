import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/repositories/guide_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetGuideUseCase {

  GetGuideUseCase(this._guideRepository);
  final GuideRepository _guideRepository;

  Future<Either<AppException, List<Channel>>> execute(String email) {
    return _guideRepository.getGuide(email);
  }
}