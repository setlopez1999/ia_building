import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercontext/supercontext.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// Custom app bar
AppBar customAppBar(
  BuildContext context, {
  Color? backgroundColor,
  String? title,
  Widget? leading,
  List<Widget>? actions,
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    backgroundColor: AppTheme.primaryColor(context),
    centerTitle: false,
    leading: leading.isNotNull
        ? leading!
        : !ModalRoute.of(context)!.isFirst
            ? IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_rounded, size: 32),
                color: AppTheme.textColor(context),
              )
            : null,
    title: GoogleTextWidget(
      title ?? '',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: Environment.h1FSize
      ),
    ),
    actions: actions,
    bottom: bottom,
  );
}
