import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/slides/slide_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class SlideRepository {
  Future<Either<AppException, List<Slide>>> getSlides();
}