import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/infraestructure/repositories/remember_repository.dart';

final rememberRepositoryProvider = Provider<RememberRepository>(
  (ref) => RememberRepository(),
);
