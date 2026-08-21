import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class Info extends ConsumerWidget {
  const Info ({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camera = ref.watch(cameraSelectedProvider);

    return SafeArea(
      top: false,
      right: false,
      left: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 82,
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: onBackPressed,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ),
          title: Row(
            spacing: 20,
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Image.asset('assets/icons/camera.png', width: 24, height: 24, color: Colors.blue)),
                ),
              ),

              GoogleTextWidget(
                camera?.name ?? 'Cámara',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: InkWell(
          onTap: onBackPressed,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: const SizedBox.expand(),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black87,
          height: 110,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoogleTextWidget(
                      'Cámara - ${camera?.id ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
