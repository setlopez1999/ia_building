import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/application/use_cases/auth/clean_session_use_case.dart';
import 'package:tvapp/core/application/use_cases/auth/get_login_info_use_case.dart';
import 'package:tvapp/core/application/use_cases/auth/get_session_use_case.dart';
import 'package:tvapp/core/application/use_cases/auth/login_token_use_case.dart';
import 'package:tvapp/core/application/use_cases/auth/login_use_case.dart';
import 'package:tvapp/core/application/use_cases/auth/save_session_use_case.dart';
import 'package:tvapp/core/domain/entities/contact/contact_entity.dart';
import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/core/services/fcm_service.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/storage/tools/local_storage.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  static const _failure = SensitiveDataEntity(parental: '', token: '', email: '', userID: '', deviceId: '');
  Timer? _timer;

  @override
  AuthState build() {
    _startSessionMonitoring();
    ref.onDispose(() => _timer?.cancel());
    return const AuthState.initial();
  }

  void _startSessionMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await loadSession(silent: true);
    });
  }

  Future<Either<AppException, Contact>> getLoginInfo() async {
    return GetLoginInfoUseCase(ref.read(authRepositoryProvider)).execute();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await LoginUseCase(ref.read(authRepositoryProvider)).execute(email, password);
    result.fold(
      (error) => state = AuthState.error(error),
      (user) => state = AuthState.success(user),
    );
  }

  Future<void> saveSession(String email) async {
    final user = state.maybeWhen(success: (user) => user, orElse: () => null);
    if (user != null) {
      await SaveSessionUseCase(ref.read(authRepositoryProvider)).execute(
        SensitiveDataEntity(
          token: user.token,
          email: email,
          parental: user.parentlockcode,
          userID: user.us_id,
          deviceId: user.devid,
        ),
      );
      final clienteId = await _fetchClienteIdFromCrm(email);
      LocalStorage.setClienteId(clienteId);
      if (clienteId.isNotEmpty) {
        FcmService.registerWithCliente(clienteId);
      }
    }
  }

  Future<String> _fetchClienteIdFromCrm(String email) async {
    try {
      final client = HttpClient();
      try {
        final uri = Uri.parse('${Environment.crmHost}/crm/clientes/by-email/${Uri.encodeComponent(email)}');
        final request = await client.getUrl(uri);
        request.headers.set('Accept', 'application/json');
        final response = await request.close();
        if (response.statusCode == 200) {
          final body = await response.transform(utf8.decoder).join();
          final data = jsonDecode(body) as Map<String, dynamic>;
          final cid = data['cliente_id'];
          if (cid != null) return cid.toString();
        }
      } finally {
        client.close();
      }
    } catch (_) {}
    return '';
  }

  Future<void> loadSession({bool silent = false}) async {
    final repo = ref.read(authRepositoryProvider);
    final session = await GetSessionUseCase(repo).execute();
    if (session.isRight()) {
      final data = session.getOrElse((AppException e) => _failure);
      if (data.token.isEmpty) {
        await CleanSessionUseCase(repo).execute();
        state = const AuthState.initial();
        return;
      }
      final loginData = await LoginTokenUseCase(repo).execute(data.token);
      await loginData.fold(
        (_) async {
          if (!silent) {
            state = const AuthState.initial();
            await CleanSessionUseCase(repo).execute();
          }
        },
        (user) async {
          final clienteId = await _fetchClienteIdFromCrm(data.email);
          LocalStorage.setClienteId(clienteId.isNotEmpty ? clienteId : data.userID);
          FcmService.registerWithCliente(clienteId.isNotEmpty ? clienteId : data.userID);
          if (!silent) state = AuthState.success(user);
        },
      );
    }
  }

  Future<void> logout() async {
    await CleanSessionUseCase(ref.read(authRepositoryProvider)).execute();
    await LocalStorage.removeClienteId();
    resetAllProviders();
    state = const AuthState.initial();
  }

  Future<(User, SensitiveDataEntity)> getAllUserInfo() async {
    final user = state.maybeWhen(success: (user) => user, orElse: () => null);
    final repo = ref.read(authRepositoryProvider);
    final sessionUseCase = await GetSessionUseCase(repo).execute();
    final session = sessionUseCase.getOrElse((AppException e) => _failure);
    return (user!, session);
  }

  void resetAllProviders() {
    ref.container.pump();
  }
}
