import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/ui/providers/settings/settings_provider.dart';
import 'package:tvapp/ui/shared/widgets/api_state.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Privacy policies
class PrivacyPolicies extends ConsumerStatefulWidget {
  const PrivacyPolicies({super.key});

  static String name = 'Privacy Policies';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivacyPoliciesState();
}

class _PrivacyPoliciesState extends ConsumerState<PrivacyPolicies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Políticas de privacidad',
      ),
      // Regla 1: los tres estados de la llamada se ven en pantalla.
      body: ref.watch(settingsProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ApiErrorView(
              failure: AppException(
                identifier: 'Configuración',
                message: 'No se pudo cargar el contenido. Intenta nuevamente.',
                statusCode: 3005,
              ),
              rawDetail: error.toString(),
              onRetry: () async => ref.invalidate(settingsProvider),
            ),
            data: (settings) => _content(context, settings.policies),
          ),
    );
  }

  Widget _content(BuildContext context, String? html) {
    if (html == null || html.trim().isEmpty) {
      return ApiErrorView(
        failure: AppException(
          identifier: 'Sin contenido',
          message: 'El contenido todavía no está disponible.',
          statusCode: 3006,
        ),
        onRetry: () async => ref.invalidate(settingsProvider),
      );
    }
    return Container(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Html(
          data: html,
          style: {'body': Style(color: AppTheme.textColor(context))},
        ),
      ),
    );
  }
}
