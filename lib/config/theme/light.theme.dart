import 'package:flutter/material.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/colors.handler.dart';
import 'package:tvapp/ui/shared/utils/env.dart';

/// Light Theme
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: swatchColorFromHexString(env('LIGHT_THEME_COLOR')),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Environment.lightThemeColor,
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(128, 39),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Environment.secondaryLightThemeColor,
      foregroundColor: Environment.secondaryLightThemeTextColor,
      textStyle: GoogleFonts.getFont(
        Environment.googleFonts,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Environment.lightThemeColorText,
    ),
  ),
  fontFamily: GoogleFonts.getFont(Environment.googleFonts).fontFamily,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      fontFamily: GoogleFonts.getFont(Environment.googleFonts).fontFamily,
      // color: Environment.inputHintColor.withOpacity(0.8),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    filled: true,
    // fillColor: Environment.inputFillColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: WidgetStatePropertyAll(
      Environment.secondaryLightThemeColor,
    ),
    side: BorderSide(
      width: 2,
      color: Environment.lightThemeColorText,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Environment.secondaryLightThemeColor,
    // selectionColor: Environment.secondaryLightThemeColor,
    // selectionHandleColor: Environment.secondaryLightThemeColor,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: GoTransitions.cupertino,
      TargetPlatform.iOS: GoTransitions.cupertino,
      TargetPlatform.macOS: GoTransitions.cupertino,
    },
  ),
);
