import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/location/get_departments_use_case.dart';
import 'package:tvapp/core/domain/entities/location/location.entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';

part 'departments_provider.g.dart';

@riverpod
class Departments extends _$Departments {

  @override
  ContentState<List<LocationEntity>> build() {
    return const ContentState.initial();
  }

  Future<void> getDepartments() async {
    final useCase = GetDepartmentsUseCase(ref.read(locationRepositoryProvider));
    final result = await useCase.execute();
    result.fold(
      (err) => state = ContentState.error(err),
      (data) => state = ContentState.success(data)
    );
  }
}
