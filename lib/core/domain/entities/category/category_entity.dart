import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';
part 'category_entity.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    @Default(0) int adulto,
    required String background,
    required String card,
    required int especial,
    required String id,
    required String name,
    required int ott,
    required String predefinido,
    @Default(0) int vod,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) => _$CategoryFromJson(json);
}
