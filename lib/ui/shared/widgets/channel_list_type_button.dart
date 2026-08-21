import 'package:flutter/material.dart';
import 'package:tvapp/config/theme/app.theme.dart';

import '../utils/list_type.enum.dart';

class ChannelListTypeButton extends StatelessWidget {
  const ChannelListTypeButton({
    super.key,
    required this.listType,
    required this.onPressed,
  });

  final ListType listType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
            width: 35,
            height: 35,
            child: MaterialButton(
              onPressed: onPressed,
              padding: EdgeInsets.zero,
              child: Icon(
                  listType == ListType.list ? Icons.apps : Icons.list_rounded,
                  size: 35,
                  color: AppTheme.textColor(context).withAlpha(150)),
              // width: 24,
              // height: 24,
            ))
      ],
    );
  }
}
