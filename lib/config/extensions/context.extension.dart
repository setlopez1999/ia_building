import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

extension ContextExtension on BuildContext {
  Future<T?> dialog<T>({
    Widget? icon,
    String? title,
    String? content,
    Widget? contentWidget,
    bool dimisible = true,
  }) async {
    return showDialog<T>(
      context: this,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.primaryColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: contentWidget ??
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppTheme.textColor(context),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (icon != null) icon else const SizedBox.shrink(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: GoogleTextWidget(
                          title ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GoogleTextWidget(
                        content ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                        ),
                      ),
                      Visibility(
                        visible: dimisible,
                        child: FilledButton(
                          onPressed: context.pop,
                          child: const Text('Cerrar', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }

  /// check connection
  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();

    if (result.first == ConnectivityResult.none) {
      await dialog(
        contentWidget: Container(
          decoration: BoxDecoration(
            color: AppTheme.textColor(this).withOpacity(0.35),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppTheme.textColor(this),
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
                          color: AppTheme.secondaryColor(this),
                        ),
                      ),
                      child: Icon(
                        Icons.wifi_off,
                        color: AppTheme.secondaryColor(this),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(this).size.width - 148,
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
                      width: MediaQuery.of(this).size.width - 148,
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
                  onPressed: pop,
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
