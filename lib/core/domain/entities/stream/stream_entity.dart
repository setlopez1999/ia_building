import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/core/domain/entities/stream_url/stream_url_entity.dart';

part 'stream_entity.freezed.dart';
part 'stream_entity.g.dart';

@freezed
abstract class StreamEntity with _$StreamEntity {
  const factory StreamEntity({
    required int audio,
    required int cdn,
    required int premium,
    required int vivo,
    required Channel channel,
    @Default([]) List<StreamUrl> url,
    @Default([]) List<Epg> epg,
    @Default(0) int catchup,
    @Default(0) int restriccion,
    @Default('') String channelLinux,
    @Default('') String channelMovil,
    @Default('') String linkLinux,
    @Default('') String linkMovil,
  }) = _StreamEntity;

  const StreamEntity._();

  String get link => linkMovil;
  bool get catchupEnabled => catchup == 1;

  factory StreamEntity.fromJson(Map<String, dynamic> json) => _$StreamEntityFromJson(json);
}