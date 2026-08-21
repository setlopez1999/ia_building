import 'package:freezed_annotation/freezed_annotation.dart';

class StringIntConverter implements JsonConverter<int, dynamic> {
  const StringIntConverter();

  @override
  int fromJson(dynamic json) {
    return int.tryParse(json.toString()) ?? 0;
  }

  @override
  int toJson(int object) {
    return object;
  }
}
