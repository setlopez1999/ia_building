import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_colors.dart';
import '../features/gaming/models/game.dart';
import '../features/gaming/providers/gaming_provider.dart';
import '../features/gaming/services/gaming_monitor_service.dart';

class GamingDetailScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GamingDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamingDetailScreen> createState() => _GamingDetailScreenState();
}

class _GamingDetailScreenState extends ConsumerState<GamingDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Set this to false to remove the green auras/glows
  final bool showGlows = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Activamos el monitor de juegos mientras estemos en esta pantalla
    ref.watch(gamingMonitorProvider);

    final gameAsync = ref.watch(gameDetailProvider(widget.gameId));

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C32),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: gameAsync.when(
          data: (game) => Text(
            game?.name ?? 'Game Details',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          loading: () => const Text('Cargando...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: gameAsync.when(
        data: (game) {
          if (game == null) {
            return const Center(child: Text('Juego no encontrado'));
          }
          return _buildContent(game);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00D285)),
        ),
        error: (err, __) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(Game game) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Ping Section with radar animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _RadarPainter(_controller.value),
                          size: const Size(280, 280),
                        );
                      },
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              game.ping.replaceAll(' ms', ''),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 86,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'ms',
                              style: TextStyle(
                                color: Color(0xFF00D285),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'LATENCIA',
                          style: TextStyle(
                            color: AppColors.textBody,
                            fontSize: 16,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Metrics Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricColumn('Pérdida', game.loss, isDivider: true),
                    _buildMetricColumn('Jitter', game.jitter, isDivider: true),
                    _buildMetricColumn(
                      'Estado',
                      game.status,
                      valueColor: const Color(0xFF00D285),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Server Card moved inside the scrollable column
                Container(
                  width: double.infinity,
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
                          const Icon(
                            Icons.dns,
                            color: Color(0xFF00D285),
                            size: 20,
                          ),
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
                        game.serverName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        game.serverLocation,
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricColumn(
    String label,
    String value, {
    bool isDivider = false,
    Color valueColor = Colors.white,
  }) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isDivider)
            Container(
              width: 1.5,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFF00D285),
                boxShadow: showGlows
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00D285).withOpacity(0.8),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double animationValue;

  _RadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF00D285).withOpacity(1.0 - animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Drawing multiple expanding circles
    for (int i = 0; i < 3; i++) {
      final value = (animationValue + i / 3) % 1.0;
      final radius = (size.width / 2) * value;
      paint.color = const Color(0xFF00D285).withOpacity(1.0 - value);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
