import 'package:flutter/material.dart';

MaterialColor swatchColorFromHexString(String hexValue) {
  final parseInt = int.parse("FF${hexValue.replaceAll("#", "")}", radix: 16);
  return MaterialColor(
    parseInt,
    {
      50: Color(parseInt).withOpacity(0.05),
      100: Color(parseInt).withOpacity(0.1),
      200: Color(parseInt).withOpacity(0.2),
      300: Color(parseInt).withOpacity(0.3),
      400: Color(parseInt).withOpacity(0.4),
      500: Color(parseInt).withOpacity(0.5),
      600: Color(parseInt).withOpacity(0.6),
      700: Color(parseInt).withOpacity(0.7),
      800: Color(parseInt).withOpacity(0.8),
      900: Color(parseInt).withOpacity(0.9),
    },
  );
}
