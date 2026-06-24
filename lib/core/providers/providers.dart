import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../../shared/data/remote/api_client.dart';
import '../../shared/data/local/local_storage.dart';

/// Cliente HTTP compartido por todos los repositorios.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: AppConstants.baseUrl);
});

/// Estado de sesión sincrónico — true si hay token en SharedPreferences.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return LocalStorage.getToken() != null;
});
