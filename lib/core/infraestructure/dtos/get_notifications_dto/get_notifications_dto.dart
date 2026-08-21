import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';

part 'get_notifications_dto.freezed.dart';
part 'get_notifications_dto.g.dart';

@freezed
abstract class GetNotificationsDto with _$GetNotificationsDto {
  const factory GetNotificationsDto({
    required List<NotificationEntity> message,
  }) = _GetNotificationDto;

  factory GetNotificationsDto.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationsDtoFromJson(json);
}