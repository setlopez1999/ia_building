import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifyme_entity.freezed.dart';
part 'notifyme_entity.g.dart';

@freezed
abstract class NotifymeEntity with _$NotifymeEntity {
  const factory NotifymeEntity({
    required int cn_id,
    required String text,
    required int user_id,
    required String scheduled_date,
    required String key
  }) = _NotifymeEntity;

  factory NotifymeEntity.fromJson(Map<String, dynamic> json) =>
      _$NotifymeEntityFromJson(json);
}