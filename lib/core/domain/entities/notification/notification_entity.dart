import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';
part 'notification_entity.g.dart';

@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required int id,
    required String title,
    required String text,
    required int read,
    @Default(0) int user_id,
    @Default(0) int topic_id,
    required String created_at,
    required String updated_at,
    /// Vacio a proposito: si el servidor no manda imagen, la app usa su propio
    /// marcador en vez de depender de un CDN externo.
    @Default('') String image_url,
  }) = _NotificationEntity;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) => _$NotificationEntityFromJson(json);
}