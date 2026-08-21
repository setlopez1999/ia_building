import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/location/get_districts_use_case.dart';
import 'package:tvapp/core/domain/entities/location/location.entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';

part 'districts_provider.g.dart';

@riverpod
class Districts extends _$Districts {

  @override
  ContentState<List<LocationEntity>> build() {
    return const ContentState.initial();
  }

  Future<void> change(String departmentCode, String provinceCode) async {
    final useCase = GetDistrictsUseCase(ref.read(locationRepositoryProvider));

    state = const ContentState.loading();

    final result = await useCase.execute(departmentCode, provinceCode);
    result.fold(
      (err) => state = ContentState.error(err),
      (data) => state = ContentState.success(data),
    );
  }

  void reset() {
    state = const ContentState.initial();
  }
}
