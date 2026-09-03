import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/screens/change_password/change_password_screen.dart';
import 'package:tvapp/ui/screens/main/main.screen.dart';
import 'package:tvapp/ui/screens/register/register.screen.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/ui/shared/widgets/app_input.widget.dart';

/// Body Widget
class BodyWidget extends ConsumerStatefulWidget {
  const BodyWidget({super.key});

  @override
  ConsumerState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<BodyWidget> {
  bool _obscureText = true;
  bool _loadingLogin = false;
  bool _checkRemember = false;
  String? _errorMsg;

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    ref.read(rememberRepositoryProvider).getRemember().then((str) {
      if(str == '') {
        return;
      }

      final splt = str.split(' __ ');
      final String ru = splt[0];
      final String rp = splt[1];

      setState(() {
        userController.text = ru;
        passController.text = rp;
        _checkRemember = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loadingLogin = true;
      _errorMsg = null;
    });

    if (!formKey.currentState!.validate()) {
      setState(() {
        _loadingLogin = false;
      });
      return;
    }

    try {
      await ref.read(authProvider.notifier).login(
            userController.text,
            passController.text,
          );

      if (!mounted) return;

      await ref.read(authProvider).maybeWhen(
            error: (exception) {
              setState(() {
                _errorMsg = exception.message;
              });
            },
            success: (user) async {
              if (_checkRemember) {
                await ref
                    .read(rememberRepositoryProvider)
                    .setRemember(userController.text, passController.text);
              } else {
                await ref.read(rememberRepositoryProvider).cleanRemember();
              }

              await ref.read(authProvider.notifier).saveSession(userController.text);
              if (!mounted) return;
              context.pushReplacementNamed(MainScreen.name);
            },
            orElse: () {},
          );
    } catch (_) {
      // Red de seguridad: ningun fallo inesperado debe dejar el boton girando.
      if (mounted) {
        setState(() {
          _errorMsg = 'Error de conexión. Intenta nuevamente.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingLogin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppAssets.logoOneplay,
                height: 24,
              ),
              // El bloque central se centra en el espacio libre y el boton
              // queda anclado abajo. El ConstrainedBox permite que, cuando el
              // teclado achica la pantalla, el contenido pueda scrollear en
              // vez de desbordar.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 28),
                          AppInput(
                            controller: userController,
                            hint: 'Usuario',
                            keyboardType: TextInputType.emailAddress,
                            enabled: !_loadingLogin,
                          ),
                          const SizedBox(height: 16),
                          AppInput(
                            controller: passController,
                            hint: 'Contraseña',
                            obscureText: _obscureText,
                            enabled: !_loadingLogin,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white54,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 32),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: _loadingLogin
                                  ? null
                                  : () {
                                      context.pushNamed(
                                          ChangePasswordScreen.name);
                                    },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ),
                          ),
                          if (_errorMsg != null) ...[
                            const SizedBox(height: 16),
                            _ErrorBanner(message: _errorMsg!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (Environment.registerEnabled) ...[
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '¿Aún no tienes cuenta?',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 6),
                          minimumSize: const Size(40, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: _loadingLogin
                            ? null
                            : () {
                                context.pushNamed(RegisterScreen.name);
                              },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _ActionButton(
                label: 'Entrar',
                isLoading: _loadingLogin,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets privados (solo vista) ─────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF44336).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: const Color(0xFFF44336).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFF44336), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFFFCDD2), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Environment.actionColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
