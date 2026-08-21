import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/error_handler/domain_exception.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';

base class ErrorHandler extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is DioException) {
      handleDioException(error, context);
    }

    if(error is DomainException){
      handleDomainException(error, context);
    }
  }

  void handleDioException(
      DioException error, ProviderObserverContext context) {
    final closeSessionEvents = [
      error.requestOptions.uri.path.contains('inicio.json') &&  error.response?.statusCode == 404,
      error.requestOptions.uri.path.contains(r'st\d+\.json') &&  error.response?.statusCode == 404,
      error.requestOptions.uri.path.contains(r'/\d+\.json') &&  error.response?.statusCode == 404,
      error.requestOptions.uri.path.contains(r'/0\.json') &&  error.response?.statusCode == 404,
    ];

    if( closeSessionEvents.isNotEmpty && closeSessionEvents.any((element) => element)){
       context.container.read(authProvider.notifier).logout();
    }

  }

  void handleDomainException(DomainException error, ProviderObserverContext context) {
    context.container.read(authProvider.notifier).logout();
  }
}
