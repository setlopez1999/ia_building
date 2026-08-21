import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

part 'content_state.freezed.dart';

@freezed
abstract class ContentState<T> with _$ContentState {
  const factory ContentState.initial() = Initial;
  const factory ContentState.loading() = Loading;
  const factory ContentState.error(AppException failure) = Error;
  const factory ContentState.success(T content) = Success;
}