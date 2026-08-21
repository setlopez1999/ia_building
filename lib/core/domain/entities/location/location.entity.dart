import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.entity.freezed.dart';
part 'location.entity.g.dart';

@freezed
abstract class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    required String code,
    required String description,
  }) = _LocationEntity;

  factory LocationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocationEntityFromJson(json);
}
