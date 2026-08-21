import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/slides/slide_entity.dart';
import 'package:tvapp/core/domain/repositories/slide_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetWelcomeUseCase {
  GetWelcomeUseCase(this._slideRepository);

  final SlideRepository _slideRepository;

  Future<Either<AppException, List<Slide>>> execute() {
    return _slideRepository.getSlides();
  }
}
