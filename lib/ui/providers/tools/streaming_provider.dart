import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/domain/entities/tools/streaming_platform.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/streaming_repository.dart';

part 'streaming_provider.g.dart';

@riverpod
StreamingRepository streamingRepository(Ref ref) {
  return StreamingRepository();
}

@riverpod
Stream<List<StreamingPlatform>> streamingPlatforms(Ref ref) {
  return ref.watch(streamingRepositoryProvider).watchPlatforms();
}

@riverpod
Stream<StreamingPlatform?> streamingPlatformDetail(
  Ref ref,
  String id,
) {
  return ref.watch(streamingRepositoryProvider).watchPlatform(id);
}
