import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/core/domain/entities/tools/streaming_platform.dart';
import 'package:tvapp/ui/providers/tools/streaming_provider.dart';

class StreamingScreen extends ConsumerWidget {
  static const String name = 'Streaming';

  const StreamingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformsAsync = ref.watch(streamingPlatformsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: const Text(
          'Streaming',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.success,
                child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Streaming Quality',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Rendimiento para video en 4K/UHD',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 20),
            platformsAsync.when(
              data: (platforms) => _PlatformListCard(
                platforms: platforms,
                onPlatformTap: (p) => context.push('/tools/streaming/detail', extra: p.id),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: AppColors.success),
              ),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PlatformListCard extends StatelessWidget {
  final List<StreamingPlatform> platforms;
  final void Function(StreamingPlatform) onPlatformTap;

  const _PlatformListCard({required this.platforms, required this.onPlatformTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: platforms
            .map((p) => _PlatformRow(platform: p, onTap: () => onPlatformTap(p)))
            .toList(),
      ),
    );
  }
}

class _PlatformRow extends StatelessWidget {
  final StreamingPlatform platform;
  final VoidCallback onTap;

  const _PlatformRow({required this.platform, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                platform.logoAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.play_arrow, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform.name,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text('Excelente', style: TextStyle(color: AppColors.textBody, fontSize: 11)),
                ],
              ),
            ),
            Text(
              platform.downloadSpeed,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
