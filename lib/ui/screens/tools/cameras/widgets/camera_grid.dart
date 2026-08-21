import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/native_player.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CameraGrid extends ConsumerWidget {

  const CameraGrid({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camerasAsync = ref.watch(cameraListProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GoogleTextWidget(
                  'Mosaico de cámaras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(onPressed: onClose, icon: const Icon(
                    Icons.close, color: Colors.white,
                ))
              ],
            ),
            const SizedBox(height: 16),

            camerasAsync.when(
                data: (cameras) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: cameras.length,
                      itemBuilder: (context, index) {
                        final camera = cameras[index];
                        void openCamera() {
                          ref.read(cameraSelectedProvider.notifier).select(camera);
                          onClose();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: openCamera,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: NativePlayer(camera: camera, muted: true),
                                  ),
                                  // Capa transparente sobre el video para capturar
                                  // el toque (el AndroidView absorbe el tap).
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: openCamera,
                              child: GoogleTextWidget(
                                camera.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.blue)),
                error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white)))),
          ],
        ),
      ),
    );
  }
}
