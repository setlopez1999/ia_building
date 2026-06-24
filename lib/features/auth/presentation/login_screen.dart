import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/branding_config.dart';
import '../logic/login_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(loginFormProvider.notifier)
        .submit(_usuarioCtrl.text.trim(), _passwordCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final branding = ref.watch(brandingProvider).valueOrNull;
    final gradient1 = branding?.colorGradient1 ?? const Color(0xFF00CC66);
    final gradient2 = branding?.colorGradient2 ?? const Color(0xFF00BEB6);
    final logoPath = branding?.logoAssetPath ?? 'assets/hub/logo_oneplay.svg';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _LoginHeader(
            gradient1: gradient1,
            gradient2: gradient2,
            logoPath: logoPath,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Email o RUT'),
                    const SizedBox(height: 8),
                    _LoginTextField(
                      controller: _usuarioCtrl,
                      hint: 'juan@email.com o 12.345.678-9',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      accentColor: gradient1,
                      validator: ref.read(loginFormProvider.notifier).validateEmail,
                    ),
                    const SizedBox(height: 20),
                    const _FieldLabel('Contraseña'),
                    const SizedBox(height: 8),
                    _LoginTextField(
                      controller: _passwordCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: formState.obscurePassword,
                      accentColor: gradient1,
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textBody,
                          size: 20,
                        ),
                        onPressed: () =>
                            ref.read(loginFormProvider.notifier).toggleObscurePassword(),
                      ),
                      validator: ref.read(loginFormProvider.notifier).validatePassword,
                    ),
                    const SizedBox(height: 16),
                    if (formState.errorMsg != null) ...[
                      _ErrorBanner(message: formState.errorMsg!),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 16),
                    _LoginButton(
                      isLoading: formState.isLoading,
                      gradient1: gradient1,
                      gradient2: gradient2,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────────────────────

class _LoginHeader extends StatelessWidget {
  final Color gradient1;
  final Color gradient2;
  final String logoPath;

  const _LoginHeader({
    required this.gradient1,
    required this.gradient2,
    required this.logoPath,
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
            logoPath,
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
  final String? Function(String?)? validator;
  final Color accentColor;

  const _LoginTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.accentColor,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textBody, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textBody, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF32324A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              colors: [gradient1, gradient2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).scale(isLoading ? 0.5 : 1.0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
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

extension _GradientScale on LinearGradient {
  LinearGradient scale(double factor) => LinearGradient(
        colors: colors
            .map((c) => c.withOpacity((c.opacity * factor).clamp(0.0, 1.0)))
            .toList(),
        begin: begin,
        end: end,
      );
}
