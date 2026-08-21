import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/providers/connectivity/internet_check_provider.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class NoInternetDialog extends ConsumerStatefulWidget {
  const NoInternetDialog({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
   return _NoInternetDialogState();
  }
}

class _NoInternetDialogState extends ConsumerState<NoInternetDialog> {
  bool showDialog = true;
  @override
  Widget build(BuildContext context) {
    return showDialog ? Dialog(
      backgroundColor: Colors.grey.shade700,
      // backgroundColor: AppTheme.textColor(context).withOpacity(0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.textColor(context),
          ), 
        ),
        child: Padding(
            padding: const EdgeInsets.all(32),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 64,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: AppTheme.secondaryColor(context),
                          ),
                        ),
                      child: Icon(
                        Icons.wifi_off,
                        color: AppTheme.secondaryColor(context),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 148,
                      child: const GoogleTextWidget(
                        'No hay conexión a internet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 148,
                      child: const GoogleTextWidget(
                        'Verifique su red de internet y vuelva a intentarlo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: (){
                    ref.read(internetCheckProvider.notifier).closeDialogManually();
                  },
                  // onPressed: () => {Navigator.of(context).pop()},
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
      ),
    ) : const SizedBox();
  }
}

