import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';

class NativePlayer extends StatelessWidget {
  final CameraEntity camera;
  final bool muted;

  const NativePlayer({super.key, required this.camera, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final url = camera.srt.isNotEmpty ? camera.srt : camera.hls;
    const String viewType = 'srt_view';
    final Map<String, dynamic> creationParams = {'url': url, 'muted': muted};

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: AndroidView(
          viewType: viewType,
          key: ValueKey('$url-$muted'),
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }

    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: Center(
        child: Text('Streaming only available on Android'),
      ),
    );
  }
}
