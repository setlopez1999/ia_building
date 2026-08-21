import 'package:flutter/material.dart';
import 'package:tvapp/config/environment/environment.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFF2C2C3E);

  // Containers
  static const Color container = Color(0xFF32324A);
  static const Color containerDark = Color(0xFF24263D);

  // Text
  static const Color textHeading = Colors.white;
  static const Color textBody = Color(0xFFB0B0C3);

  // Brand / accent
  static const Color primary = Color.fromARGB(255, 29, 240, 10);
  static const Color accentPurple = Color(0xFF4A4A6A);
  static const Color accentBlue = Color(0xFF7B61FF);

  // Status
  static const Color success = Color(0xFF00D285);
  static const Color error = Color(0xFFFF4B55);
  static const Color warning = Color(0xFFFF9800);

  // Icons secundarios (svg filters, etc.)
  static const Color iconSecondary = Color(0xB3FFFFFF); // white70

  // Gradiente wifi card — estado OK (valores vienen del .env)
  static Color gradientOk1 = Environment.gradientColor1;
  static Color gradientOk2 = Environment.gradientColor2;

  // Gradiente wifi card — estado DEGRADADO
  static const Color gradientDegradado1 = Color(0xFFE65C00);
  static const Color gradientDegradado2 = Color(0xFFF9D423);

  // Gradiente wifi card — desconectado
  static const Color gradientDesconectado1 = Color(0xFF616161);
  static const Color gradientDesconectado2 = Color(0xFF757575);
}
