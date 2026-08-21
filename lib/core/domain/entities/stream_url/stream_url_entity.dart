import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_url_entity.freezed.dart';
part 'stream_url_entity.g.dart';

@freezed
abstract class StreamUrl with _$StreamUrl {
  const factory StreamUrl({
    required String link,
    required int primario,
    @Default('') String channel,
  }) = _StreamUrl;

  factory StreamUrl.fromJson(Map<String, dynamic> json) => _$StreamUrlFromJson(json);
}