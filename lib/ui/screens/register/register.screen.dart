import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/register/register_notifier.dart';
import 'package:tvapp/ui/screens/register/register-confirmation.screen.dart';
import 'package:tvapp/ui/screens/register/wigdets/location_data.register_from.widget.dart';
import 'package:tvapp/ui/screens/register/wigdets/personal_data.register_form.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Register Screen
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static String name = 'register';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  RegisterUserDto? _personalData;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Volver atrás dentro del flujo no pierde nada: el paso 2 regresa al paso 1
  /// y los datos siguen en memoria. Solo salir del registro los descarta, y
  /// por eso se pide confirmación.
  Future<void> _handleBack() async {
    if (currentIndex == 1) {
      setState(() {
        currentIndex = 0;
      });
      _tabController.animateTo(0);
      return;
    }

    final salir = await _confirmarSalida();
    if (salir == true && mounted) {
      context.pop();
    }
  }

  Future<bool?> _confirmarSalida() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.container,
        title: const Text(
          '¿Salir del registro?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Si sales ahora se perderán los datos que ingresaste.',
          style: TextStyle(color: AppColors.textBody),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Seguir registrándome',
              style: TextStyle(color: AppColors.textBody),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Salir',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// El motivo del fallo lo decide la respuesta del API (correo duplicado,
  /// datos inválidos, etc.). El detalle crudo del servidor solo se muestra
  /// con `APP_DEBUG_MODE=true` — Regla 1.b de docs/REGLAS.md.
  Future<void> _mostrarError(AppException error) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.container,
        icon: const Icon(Icons.error_outline, color: AppColors.error, size: 44),
        title: const Text(
          'No pudimos completar tu registro',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textBody, fontSize: 14),
              ),
              if (Environment.appDebugMode && error.detail != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orangeAccent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DEBUG — respuesta del servidor',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        error.detail!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerProvider, (_, next) {
      if (next is RegisterSuccess) {
        context.pushReplacementNamed(RegisterConfirmationScreen.name);
      } else if (next is RegisterError) {
        _mostrarError(next.error);
      }
    });

    return PopScope(
      // canPop:false para interceptar también el botón atrás del sistema,
      // no solo la flecha de la barra.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: 'Registro',
          leading: IconButton(
            onPressed: _handleBack,
            icon: const Icon(Icons.arrow_back, size: 32),
            color: AppTheme.textColor(context),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            PersonalDataForm(
              personalData: _personalData,
              onNext: (personalData) {
                setState(() {
                  currentIndex = 1;
                  _personalData = personalData;
                });
                _tabController.animateTo(1);
              },
            ),
            LocationDataForm(
              onConfirm: ({
                String departmentCode = '',
                String provinceCode = '',
                String districtCode = '',
                bool acceptTerms = false,
                bool acceptPolicies = false,
              }) async {
                await ref.read(registerProvider.notifier).submit(
                      personalData: _personalData!,
                      departmentCode: departmentCode,
                      provinceCode: provinceCode,
                      districtCode: districtCode,
                      acceptTerms: acceptTerms,
                      acceptPolicies: acceptPolicies,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
