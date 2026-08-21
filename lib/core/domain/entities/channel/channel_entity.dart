import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';

part 'channel_entity.freezed.dart';
part 'channel_entity.g.dart';

@freezed
abstract class Channel with _$Channel {
  const factory Channel({
    required int adulto,
    @Default(0) int category_id,
    required String card,
    required String description,
    required int number,
    @Default(0) int premium,
    @Default(0) int restriccion,
    @Default(0) int seccion_id,
    required int studio,
    required String title,
    @Default([]) List<Epg>? epg
  }) = _Channel;

  const Channel._();

  bool get isAdulto => adulto == 1;

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
}