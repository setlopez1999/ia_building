import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/domain/repositories/category_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<Either<AppException, List<Category>>> execute(String token) {
    return _categoryRepository.getCategories(token);
  }
}
