import 'package:freezed_annotation/freezed_annotation.dart';

part 'streaming_platform.freezed.dart';
part 'streaming_platform.g.dart';

@freezed
class StreamingPlatform with _$StreamingPlatform {
  const factory StreamingPlatform({
    required String id,
    required String name,
    required String logoAsset,
    required String downloadSpeed,
    required String uploadSpeed,
    required String serverName,
    required String serverLocation,
  }) = _StreamingPlatform;

  factory StreamingPlatform.fromJson(Map<String, dynamic> json) =>
      _$StreamingPlatformFromJson(json);
}
