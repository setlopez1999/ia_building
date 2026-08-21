import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';

/// Google Text Span Widget
TextSpan googleTextSpan(
  context, {
  String? value,
  TextStyle? style,
  List<InlineSpan>? children,
  VoidCallback? onTap,
}) {
  return TextSpan(
    text: value,
    style: GoogleFonts.getFont(
      Environment.googleFonts,
      textStyle: TextStyle(
        color: style?.color ?? AppTheme.textColor(context),
        fontSize: style?.fontSize,
        fontWeight: style?.fontWeight,
      ),
    ),
    recognizer: TapGestureRecognizer()..onTap = onTap,
    children: children,
  );
}

/// Google styles
TextStyle googleStyle(BuildContext context, {TextStyle? match}) {
  return GoogleFonts.getFont(
    Environment.googleFonts,
    textStyle: TextStyle(
      color: Environment.inputTextColor,
      fontSize: match?.fontSize ?? 18,
      fontWeight: match?.fontWeight ?? FontWeight.w600,
    ),
  );
}
