import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CameraList extends ConsumerWidget {
  const CameraList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camerasAsync = ref.watch(cameraListProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: GoogleTextWidget('Lista de cámaras',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 10,),
          camerasAsync.when(
              data: (cameras) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: cameras.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.transparent,
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: Image.asset('assets/icons/camera.png',
                                  width: 24, height: 24, color: Colors.blue),
                            )),
                        title: Text(
                          cameras[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          ref.read(cameraSelectedProvider.notifier).select(cameras[index]);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.blue)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}
