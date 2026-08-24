import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/screens/change_password/change_password_screen.dart';
import 'package:tvapp/ui/screens/main/main.screen.dart';
import 'package:tvapp/ui/screens/register/register.screen.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';

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

    if (mounted) {
      setState(() {
        _loadingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient1 = Environment.gradientColor1;
    final gradient2 = Environment.gradientColor2;

    return Form(
      key: formKey,
      child: SafeArea(
        child: Column(
          children: [
            _LoginHeader(
              gradient1: gradient1,
              gradient2: gradient2,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Usuario'),
                    const SizedBox(height: 8),
                    _LoginTextField(
                      controller: userController,
                      hint: 'Ingresa tu usuario',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      accentColor: gradient1,
                      enabled: !_loadingLogin,
                    ),
                    const SizedBox(height: 20),
                    const _FieldLabel('Contraseña'),
                    const SizedBox(height: 8),
                    _LoginTextField(
                      controller: passController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: _obscureText,
                      accentColor: gradient1,
                      enabled: !_loadingLogin,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Environment.inputHintColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _loadingLogin
                          ? null
                          : () {
                              setState(() {
                                _checkRemember = !_checkRemember;
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recordar contraseña',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Checkbox(
                            value: _checkRemember,
                            checkColor: AppTheme.secondaryColor(context),
                            activeColor: Colors.white,
                            onChanged: _loadingLogin
                                ? null
                                : (checked) {
                                    setState(() {
                                      _checkRemember = checked ?? false;
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: _loadingLogin
                            ? null
                            : () {
                                context.pushNamed(ChangePasswordScreen.name);
                              },
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: AppTheme.secondaryColor(context),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    if (_errorMsg != null) ...[
                      const SizedBox(height: 16),
                      _ErrorBanner(message: _errorMsg!),
                    ],
                    const SizedBox(height: 24),
                    if (Environment.registerEnabled) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Aún no tienes cuenta?',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: _loadingLogin
                                ? null
                                : () {
                                    context.pushNamed(RegisterScreen.name);
                                  },
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                color: AppTheme.secondaryColor(context),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    _LoginButton(
                      isLoading: _loadingLogin,
                      gradient1: gradient1,
                      gradient2: gradient2,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets privados (solo vista) ─────────────────────────────────────────────

class _LoginHeader extends StatelessWidget {
  final Color gradient1;
  final Color gradient2;

  const _LoginHeader({
    required this.gradient1,
    required this.gradient2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 70, bottom: 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradient1, gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            AppAssets.logoOneplay,
            height: 52,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(height: 14),
          const Text(
            'Bienvenido',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ingresa con tu cuenta para continuar',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Color accentColor;
  final bool enabled;

  const _LoginTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.accentColor,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Campo requerido' : null,
      style: TextStyle(color: Environment.inputTextColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Environment.inputHintColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: Environment.inputHintColor, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Environment.inputFillColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Color(0xFFF44336), fontSize: 12),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF44336)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF44336)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFF44336), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFF44336), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final Color gradient1;
  final Color gradient2;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.isLoading,
    required this.gradient1,
    required this.gradient2,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradient1.withOpacity(isLoading ? 0.5 : 1.0),
                gradient2.withOpacity(isLoading ? 0.5 : 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text(
                    'Ingresar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
