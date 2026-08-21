import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercontext/supercontext.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';

/// Google Text Widget
class GoogleTextWidget extends ConsumerWidget {
  const GoogleTextWidget(
    this.value, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String value;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      value,
      style: GoogleFonts.getFont(
        Environment.googleFonts,
        textStyle: TextStyle(
          color: style?.color ?? AppTheme.textColor(context),
          fontSize: style?.fontSize ?? 18,
          fontWeight: style?.fontWeight,
        ),
      ),
      overflow: maxLines.isNotNull ? TextOverflow.ellipsis : null,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
