
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/multicdn/get_url_use_case.dart';
import 'package:tvapp/core/providers/repository_providers.dart';

part 'multicdn_provider.g.dart';

@Riverpod(keepAlive: true)
class MultiCDN extends _$MultiCDN {
  Timer? _timer;
  @override
  ContentState<String> build() {
    _startMonitoring();

    ref.onDispose(() {
      _timer?.cancel();
    });

    return const ContentState.initial();
  }

  Future<void> _startMonitoring() async {
    final useCase = GetURLUseCase(ref.read(multicdnRepositoryProvider));

    _timer?.cancel();

   if(Environment.multicdnEnabled)  {
     print('MultiCDN enabled start monitor');
     final result = await useCase.execute();

     state = result.fold(
       ContentState.error,
       ContentState.success,
     );
     print(state.maybeWhen(orElse: () => 'error Obteniendo Multicdn', success: (url) => 'MultiCDN: url: $url'));
       _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
         final result = await useCase.execute();

         state = result.fold(
           ContentState.error,
           ContentState.success,
         );

         print(state.maybeWhen(orElse: () => 'error Obteniendo Multicdn', success: (url) => 'MultiCDN: url: $url'));
       });
     }
  }
}
