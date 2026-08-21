import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/providers/favorites/favorites_provider.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton(this.channel, {
    super.key,
    this.width = 50,
    this.height = 70,
    this.withLabel = false,
  });

  final Channel channel;
  final double width;
  final double height;
  final bool withLabel;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  bool _localFavoriteState = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _localFavoriteState = ref.read(favoritesProvider.notifier).isFavorite(widget.channel.number);
  }

  Future<void> _handleFavoriteToggle() async {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _localFavoriteState = !_localFavoriteState;
    });

    await BaseButtonChannel.toggleFavorite(widget.channel, ref);

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    return favorites.maybeWhen(
      success: (_) => InkWell(
        onTap: _handleFavoriteToggle,
        child: Row(
          children: [
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: Center(
                child: _localFavoriteState
                    ? Icon(
                  Icons.add_circle_rounded,
                  color: AppTheme.secondaryColor(context),
                )
                    : const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white38,
                ),
              ),
            ),
            if(widget.withLabel)
              GoogleTextWidget('${!_localFavoriteState ? 'Añadir a' : 'Quitar de'} favoritos'),
          ],
        ),
      ),
      initial: () {
        Future.microtask(() {
          ref.read(favoritesProvider.notifier).get(silent: true);
        });
        return const SizedBox();
      },
      orElse: SizedBox.new,
    );
  }
}
