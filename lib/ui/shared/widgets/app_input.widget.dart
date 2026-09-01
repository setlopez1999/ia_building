import 'package:flutter/material.dart';
import 'package:tvapp/config/environment/environment.dart';

/// Campo de entrada único de la app — Regla 3 de `docs/REGLAS.md`.
///
/// Define el estilo completo (relleno, borde, radio, padding, tipografía y
/// estados) sin depender del `inputDecorationTheme` global, que todavía está
/// configurado para un tema claro y pinta los campos de blanco.
///
/// Las únicas excepciones permitidas son las anotadas en `docs/REGLAS.md`
/// (chat y wifi password, del módulo Check Health).
class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final bool autofocus;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  /// Tokens compartidos. Cambiar acá cambia todos los campos de la app.
  static const double radius = 10;
  static const Color borderColor = Colors.white24;
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.white54;
  static const Color errorColor = Color(0xFFF44336);
  static const double fontSize = 14;
  static const EdgeInsets padding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 18);

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color),
      );

  /// Decoración compartida, para widgets que no son `TextFormField`
  /// (por ejemplo los desplegables del registro).
  static InputDecoration decoration({
    required String hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: hintColor, fontSize: fontSize),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      filled: false,
      contentPadding: padding,
      border: _border(borderColor),
      enabledBorder: _border(borderColor),
      disabledBorder: _border(borderColor),
      focusedBorder: _border(Environment.actionColor),
      errorStyle: const TextStyle(color: errorColor, fontSize: 12),
      errorBorder: _border(errorColor),
      focusedErrorBorder: _border(errorColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      autofocus: autofocus,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: textColor, fontSize: fontSize),
      decoration: decoration(
        hint: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

/// Variante de búsqueda: mismo lenguaje visual, en una sola línea y sin
/// validación. Se usa en los buscadores de IPTV y de cámaras.
class AppSearchInput extends StatelessWidget {
  const AppSearchInput({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: controller,
      hint: hint,
      autofocus: autofocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: prefixIcon ??
          const Icon(Icons.search, color: AppInput.hintColor, size: 20),
      suffixIcon: suffixIcon,
      onChanged: onChanged,
    );
  }
}
