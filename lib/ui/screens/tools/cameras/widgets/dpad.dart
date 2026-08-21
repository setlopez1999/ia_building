import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';

class DPad extends ConsumerStatefulWidget {
  const DPad({super.key});

  @override
  ConsumerState<DPad> createState() => _DPadState();
}

class _DPadState extends ConsumerState<DPad> {
  DateTime? _lastPressed;

  bool _canPress() {
    final now = DateTime.now();
    final last = _lastPressed;
    if (last == null || now.difference(last) > const Duration(seconds: 1)) {
      _lastPressed = now;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(cameraSelectedProvider);

    if (camera == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            _buildArrowButton(
              icon: Icons.arrow_upward_outlined,
              alignment: Alignment.topCenter,
              y: 0.05,
            ),
            _buildArrowButton(
              icon: Icons.arrow_downward_outlined,
              alignment: Alignment.bottomCenter,
              y: -0.05,
            ),
            _buildArrowButton(
              icon: Icons.arrow_back_outlined,
              alignment: Alignment.centerLeft,
              x: -0.05,
            ),
            _buildArrowButton(
              icon: Icons.arrow_forward_outlined,
              alignment: Alignment.centerRight,
              x: 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required Alignment alignment,
    double x = 0,
    double y = 0,
  }) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          if (_canPress()) {
            ref.read(cameraSelectedProvider.notifier).move(x, y);
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
