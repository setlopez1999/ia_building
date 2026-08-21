import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class CategoryRepository {
  Future<Either<AppException, List<Category>>> getCategories(String token);
}