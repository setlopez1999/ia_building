import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/channel_playing/channel_playing_provider.dart';
import 'package:tvapp/ui/providers/favorites/favorites_provider.dart';
import 'package:tvapp/ui/screens/player/player_screen.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';


class BaseButtonChannel {

  BaseButtonChannel._();

  static bool working = false;
  static bool workingPlayer = false;

  static Future<void> playChannel({
    required Channel channel,
    required WidgetRef ref,
    required BuildContext context,
    bool silent = false,
    bool fromHome = false,
  }) async {

    if(BaseButtonChannel.working) {
      return;
    }
    BaseButtonChannel.working = true;

    final List<Category> categories = ref.read(categoriesProvider).maybeWhen(
        orElse: () => [],
        success: (categories) => categories);

    final categoryLaunched = categories.firstWhere((element) => element.id == channel.category_id.toString());

    await ref.read(categorySelectedProvider.notifier).selectCategory(categoryLaunched);

    try {
      await ref
          .read(channelPlayingProvider.notifier)
          .setChannel(channel, silent: silent, fromHome: fromHome);
    }catch(e, stacktrace) {
      print(e);
      print(stacktrace);
      BaseButtonChannel.working = false;
      return;
    }

    if(context.mounted && !silent) {
      BaseButtonChannel.working = false;
      await context.pushNamed(PlayerScreen.name);
      return;
    }

    BaseButtonChannel.working = false;
    return;
  }

  static Future<void> toggleFavorite(Channel channel, WidgetRef ref) async {
    await ref.read(favoritesProvider.notifier).toggleFavorite(channel);
    await ref.read(favoritesProvider.notifier).get(silent: true);
  }

  static Future<void> toLeft(WidgetRef ref) async {
    if(BaseButtonChannel.working) {
      return;
    }
    BaseButtonChannel.working = true;
    await ref.read(channelPlayingProvider.notifier).toLeft();
    BaseButtonChannel.working = false;
  }

  static Future<void> toRight(WidgetRef ref) async {
    if(BaseButtonChannel.working) {
      return;
    }
    BaseButtonChannel.working = true;
    await ref.read(channelPlayingProvider.notifier).toRight();
    BaseButtonChannel.working = false;
  }

  static Future<bool?> validateAdultPassword(
      BuildContext context, WidgetRef ref, StreamEntity stream) async {
    final adultTextController = TextEditingController();
    final passwordFocusNode = FocusNode();
    final result = await ref.read(authProvider.notifier).getAllUserInfo();
    final parentToken = result.$2.parental;
    bool isInvalid = false;
    bool isTaped = false;

    return showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) =>  AlertDialog(
            actionsPadding: const EdgeInsets.only(bottom: 8, right: 14),
            actionsOverflowButtonSpacing: 16,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            buttonPadding: const EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: AppTheme.primaryColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: AppTheme.secondaryColor(context),
              ),
            ),
            titlePadding: const EdgeInsets.all(8),
            titleTextStyle: const TextStyle(
              color: Colors.white,
            ),
            title: Text(Environment.parentalTitle),
            content: SizedBox(
              width: 300,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.number,
                    controller: adultTextController,
                    style: TextStyle(
                      color: AppTheme.primaryColor(context),
                      fontSize: 12
                    ),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: Environment.parentalPlaceholder,
                      hintStyle: TextStyle(fontSize: 14, color: AppTheme.secondaryColor(context)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                      isDense: true,
                      // Aplicamos el borde rojo cuando isInvalid es true
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isInvalid ? Colors.red : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isInvalid ? Colors.red : AppTheme.secondaryColor(context),
                        ),
                      ),
                      // errorText: isInvalid ? 'PIN incorrecto' : null,
                    ),
                    obscureText: true,
                  ),
                  if(Environment.showParentalDescription)
                    SizedBox(height: 4),
                  if(Environment.showParentalDescription)
                    GoogleTextWidget(stream.channel.description,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 2
                    ),
                  if(Environment.showParentalDescription)
                    InkWell(
                      onTap: () => setState(() => isTaped = true),
                      child: GoogleTextWidget('Suscríbete',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isTaped
                                ? AppTheme.secondaryColor(context).withAlpha(100)
                                : AppTheme.secondaryColor(context) )
                        ,),
                    ),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () => context.pop(),
                child: const GoogleTextWidget('Cancelar', style: TextStyle(fontSize: 12),),
              ),
              InkWell(
                onTap: () async {
                  final plainText = adultTextController.text;
                  final isValid = DBCrypt().checkpw(plainText, parentToken);

                  if (isValid) {
                    if (context.mounted) {
                      context.pop(true);
                    }
                  } else {
                    // Si no es válido, actualizamos el estado para mostrar el error
                    setState(() {
                      isInvalid = true;
                    });

                    // Limpiamos el campo y devolvemos el foco
                    adultTextController.clear();
                    passwordFocusNode.requestFocus();
                  }
                },
                child: const GoogleTextWidget('Aceptar', style: TextStyle(fontSize: 12),),
              ),
            ],
          ),
        ));
  }

  static Future<void> selectCategory(Category category, WidgetRef ref) async {

    if(BaseButtonChannel.workingPlayer) {
      return;
    }
    BaseButtonChannel.workingPlayer = true;
    await ref.read(categorySelectedProvider.notifier).selectCategory(category);
    BaseButtonChannel.workingPlayer = false;
  }
}
