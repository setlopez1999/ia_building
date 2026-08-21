import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/application/use_cases/auth/register_user_use_case.dart';
import 'package:tvapp/core/application/use_cases/settings/get_settings_use_case.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

sealed class RegisterState {
  const RegisterState();
}

class RegisterIdle extends RegisterState {
  const RegisterIdle();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess();
}

class RegisterError extends RegisterState {
  const RegisterError(this.error);
  final AppException error;
}

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterIdle();

  Future<void> submit({
    required RegisterUserDto personalData,
    required String departmentCode,
    required String provinceCode,
    required String districtCode,
    required bool acceptTerms,
    required bool acceptPolicies,
  }) async {
    state = const RegisterLoading();

    final settingsResult = await GetSettingsUseCase(ref.read(settingsRepositoryProvider)).execute();

    await settingsResult.fold(
      (error) async => state = RegisterError(error),
      (settings) async {
        final result = await RegisterUserUseCase(ref.read(authRepositoryProvider)).execute(
          settings: settings,
          params: personalData,
          departmentCode: departmentCode,
          provinceCode: provinceCode,
          districtCode: districtCode,
          acceptTerms: acceptTerms,
          acceptPolicies: acceptPolicies,
        );
        result.fold(
          (error) => state = RegisterError(error),
          (_) => state = const RegisterSuccess(),
        );
      },
    );
  }

  void reset() => state = const RegisterIdle();
}

final registerProvider = NotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);
