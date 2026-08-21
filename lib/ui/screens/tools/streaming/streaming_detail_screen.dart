import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/core/domain/entities/tools/streaming_platform.dart';
import 'package:tvapp/ui/providers/tools/streaming_provider.dart';
import 'package:tvapp/ui/providers/tools/streaming_monitor_service.dart';

class StreamingDetailScreen extends ConsumerWidget {
  static const String name = 'Streaming Detail';

  final String platformId;
  const StreamingDetailScreen({super.key, required this.platformId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(streamingMonitorProvider(platformId));
    final platformAsync = ref.watch(streamingPlatformDetailProvider(platformId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: platformAsync.when(
          data: (p) => Text(p?.name ?? 'Streaming Details',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          loading: () => const Text('Cargando...', style: TextStyle(color: Colors.white)),
          error: (_, __) => const Text('Error', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: platformAsync.when(
        data: (platform) {
          if (platform == null) {
            return const Center(
              child: Text('Plataforma no encontrada', style: TextStyle(color: Colors.white)),
            );
          }
          return _PlatformContent(platform: platform);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.success)),
        error: (err, __) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _PlatformContent extends StatelessWidget {
  final StreamingPlatform platform;
  const _PlatformContent({required this.platform});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              platform.logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.play_arrow, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 15),
          Text(platform.name,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _SpeedCard(label: 'BAJADA', value: platform.downloadSpeed.split(' ')[0], icon: Icons.arrow_downward),
              _SpeedCard(label: 'SUBIDA', value: platform.uploadSpeed.split(' ')[0], icon: Icons.arrow_upward),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.containerDark,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.dns, color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Text('SERVIDOR',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                  ],
                ),
                const SizedBox(height: 15),
                Text(platform.serverName,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(platform.serverLocation,
                    style: const TextStyle(color: AppColors.textBody, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SpeedCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SpeedCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.containerDark, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.success, size: 30),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 2),
              const Text('Mbps',
                  style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
