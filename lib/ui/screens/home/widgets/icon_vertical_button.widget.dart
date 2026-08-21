import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/shared/utils/check_index.handler.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class IconVerticalButton extends StatelessWidget {

  const IconVerticalButton({
    super.key,
    required this.iconPath,
    required this.selected,
    required this.text,
    required this.onPressed,
  });

  final bool selected;
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: selected ? AppTheme.secondaryColor(context) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
            const SizedBox(height: 4),
            GoogleTextWidget(
              text,
              style: TextStyle(
                color: AppTheme.textColor(context),
                fontWeight: FontWeight.w700,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
