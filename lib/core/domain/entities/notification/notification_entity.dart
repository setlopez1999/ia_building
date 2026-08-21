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
    @Default('https://cdn-icons-png.flaticon.com/512/4226/4226663.png') String image_url,
  }) = _NotificationEntity;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) => _$NotificationEntityFromJson(json);
}