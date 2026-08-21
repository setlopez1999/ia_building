import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/slides/slide_entity.dart';
import 'package:tvapp/core/domain/repositories/slide_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class SlideHttpRepository implements SlideRepository {
  @override
  Future<Either<AppException, List<Slide>>> getSlides() async {
    final Dio dio = Dio();
    final res = await dio.get('${Environment.baseHost}/api/get-slidersmovil');

    final data = res.data!;

    if (data is Map && data.containsKey('code') && data['code'] == 400) {
      return Left(AppException(
          statusCode: 5001,
          message: 'Error al obtener los sliders',
          identifier: 'Error'));
    }

    if(data['sliders'] == null) {
      return Left(AppException(
          statusCode: 5001,
          message: 'Error al obtener los sliders',
          identifier: 'Error'));
    }

    final list = data['sliders']
        .map<Slide>((dynamic item) => Slide.fromJson(item as Map<String, dynamic>));

    return Right(list.toList());
  }
}