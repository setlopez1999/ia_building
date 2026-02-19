import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_colors.dart';
import '../features/streaming/models/streaming_platform.dart';
import '../features/streaming/providers/streaming_provider.dart';
import '../features/streaming/services/streaming_monitor_service.dart';

class StreamingDetailScreen extends ConsumerWidget {
  final String platformId;

  const StreamingDetailScreen({super.key, required this.platformId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activamos el monitor de streaming mientras estemos en esta pantalla
    ref.watch(streamingMonitorProvider);

    final platformAsync = ref.watch(
      streamingPlatformDetailProvider(platformId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: platformAsync.when(
          data: (platform) => Text(
            platform?.name ?? 'Streaming Details',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          loading: () => const Text('Cargando...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: platformAsync.when(
        data: (platform) {
          if (platform == null) {
            return const Center(child: Text('Plataforma no encontrada'));
          }
          return _buildContent(platform);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00D285)),
        ),
        error: (err, __) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(StreamingPlatform platform) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Platform Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              platform.logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.play_arrow, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            platform.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          // Download/Upload Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildSpeedCard(
                'BAJADA',
                platform.downloadSpeed.split(' ')[0],
                'Mbps',
                Icons.arrow_downward,
              ),
              _buildSpeedCard(
                'SUBIDA',
                platform.uploadSpeed.split(' ')[0],
                'Mbps',
                Icons.arrow_upward,
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Server Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF24263D),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.dns, color: Color(0xFF00D285), size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'SERVIDOR',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  platform.serverName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  platform.serverLocation,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedCard(
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF24263D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF00D285), size: 30),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: const TextStyle(
                  color: Color(0xFF00D285),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
