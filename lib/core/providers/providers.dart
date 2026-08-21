import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final apiClientProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
});
