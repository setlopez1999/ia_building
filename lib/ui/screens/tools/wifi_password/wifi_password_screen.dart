import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/wifi_notifier.dart';
import 'package:tvapp/ui/screens/tools/check_health/check_health_screen.dart';

class WifiPasswordScreen extends ConsumerStatefulWidget {
  static const String name = 'wifi-password';
  static const String path = '/tools/wifi-password';

  final String ssid;

  const WifiPasswordScreen({super.key, required this.ssid});

  @override
  ConsumerState<WifiPasswordScreen> createState() => _WifiPasswordScreenState();
}

class _WifiPasswordScreenState extends ConsumerState<WifiPasswordScreen> {
  final _newPassCtrl = TextEditingController();
  final _repeatPassCtrl = TextEditingController();
  bool _obscureNew = true;
  bool _obscureRepeat = true;
  String? _validationError;

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _repeatPassCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _validationError = null);
    final nueva = _newPassCtrl.text.trim();
    final repeat = _repeatPassCtrl.text.trim();

    if (nueva.isEmpty) {
      setState(() => _validationError = 'Ingresa la nueva contraseña');
      return;
    }
    if (nueva != repeat) {
      setState(() => _validationError = 'Las contraseñas no coinciden');
      return;
    }

    ref.read(wifiProvider.notifier).cambiarPassword(nueva);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<WifiActionState>(wifiProvider, (_, next) {
      if (next.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada'),
            backgroundColor: AppColors.success,
          ),
        );
        context.goNamed(CheckHealthScreen.name);
      }
    });

    final state = ref.watch(wifiProvider);
    final errorMsg = _validationError ?? state.errorMsg;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Cambiar clave de red',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _SsidCard(ssid: widget.ssid),
            const SizedBox(height: 20),
            _PassField(
              controller: _newPassCtrl,
              hint: 'Nueva contraseña',
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 12),
            _PassField(
              controller: _repeatPassCtrl,
              hint: 'Repetir nueva contraseña',
              obscure: _obscureRepeat,
              onToggle: () => setState(() => _obscureRepeat = !_obscureRepeat),
            ),
            if (errorMsg != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMsg,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ],
            const Spacer(),
            _SubmitButton(isLoading: state.isLoading, onTap: _submit),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SsidCard extends StatelessWidget {
  final String ssid;
  const _SsidCard({required this.ssid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              ssid.isEmpty ? '--' : ssid,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;

  const _PassField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textBody),
        filled: true,
        fillColor: AppColors.container,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textBody,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: const BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : const Text(
                  'Cambiar clave',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
