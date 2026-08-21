import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/channels_searched/channels_searched_provider.dart';
import 'package:tvapp/ui/screens/login/login.screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/row_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  static String name = 'Search';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  bool _hasSpeech = false;
  bool _isListening = false;
  List<Channel> _json = [];
  List<Channel>? _searchJson;
  String _text = '';
  final SpeechToText _speech = SpeechToText();

  final _searchController = TextEditingController();


  Future<void> initSpeechState() async {
    log('initiaize');
    try {
      final hasSpeech = await _speech.initialize();

      if (!mounted) {
        return;
      }

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      log('error on initSpeechState', error: e);
    }
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> _startListening() async {
    log(_hasSpeech.toString());
    if (_hasSpeech) {
      setState(() {
        _searchJson = null;
        _isListening = true;
        _text = '';
      });
      _searchController.text = '';
      await _speech.listen(
        onResult: (val) {
          setState(
                () {
              _text = val.recognizedWords;
              _searchInJson(_text);
            },
          );
          _searchController.text = val.recognizedWords;
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  String normalize(String input){
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '') //Remueve espacios
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  void _searchInJson(String text) {
    setState(() {
      _searchJson = _json
          .where((json) => normalize(json.title)
          .contains(normalize(text.toLowerCase().trim())))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchableData = ref.watch(channelsSearchedProvider);
    return searchableData.when(
      success: (json) {
        setState(() {
          _json = json;
        });
        return SafeArea(
          child: Scaffold(
            appBar: customAppBar(
              context,
              title: 'Buscador',
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _searchController,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) => {
                            _searchInJson(value)
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hintText: '¿Qué canal buscas?',
                            hintStyle: TextStyle(
                              color: AppTheme.textColor(context),
                            ),
                            prefixIcon: _speech.isListening
                                ? Icon(
                              Icons.graphic_eq,
                              color: AppTheme.secondaryColor(context),
                            )
                                : null,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                        _isListening ? _stopListening : _startListening,
                        icon: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          color: AppTheme.secondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (BuildContext context, int index) {
                final Channel channel = _searchJson?[index] ?? json[index];
                return RowButtonChannel(channel: channel);
              },
              itemCount: _searchJson?.length ?? json.length,
            ),
          ),
        );
      },
      error: (error) {
        if(error.statusCode == 3001){
          Future.microtask(() async {
            await  ref.read(authProvider.notifier).logout();
          });
        }
        return const SizedBox();
      },
      initial: () {
        Future.microtask(()=> ref.read(channelsSearchedProvider.notifier).get());
        return const GoogleTextWidget('');
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: AppTheme.secondaryColor(context),
        ),
      ),
    );
  }
}
