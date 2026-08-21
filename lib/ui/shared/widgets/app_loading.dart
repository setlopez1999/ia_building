import 'package:flutter/material.dart';
import 'package:tvapp/core/theme/app_colors.dart';

/// Widget de carga reutilizable.
///
/// Uso inline (dentro de un cuerpo):
///   AppLoading()
///   AppLoading(message: 'Cargando historial...')
///
/// Uso como pantalla completa:
///   AppLoading.screen()
///   AppLoading.screen(message: 'Iniciando...')
class AppLoading extends StatelessWidget {
  final String? message;
  final bool _fullScreen;

  const AppLoading({
    super.key,
    this.message,
  }) : _fullScreen = false;

  const AppLoading.screen({
    super.key,
    this.message,
  }) : _fullScreen = true;

  Widget _content() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: AppColors.accentBlue,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textBody,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_fullScreen) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: _content(),
      );
    }
    return _content();
  }
}
