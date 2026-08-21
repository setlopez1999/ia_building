import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/contact/contact_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';

final loginInfoProvider = FutureProvider.autoDispose<Contact>((ref) async {
  final result = await ref.read(authProvider.notifier).getLoginInfo();
  return result.fold(
    (AppException error) => throw Exception(error.message),
    (contact) => contact,
  );
});
