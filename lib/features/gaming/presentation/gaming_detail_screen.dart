import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../models/game.dart';
import '../providers/gaming_provider.dart';
import '../services/gaming_monitor_service.dart';

class GamingDetailScreen extends ConsumerStatefulWidget {
  final String gameId;
  const GamingDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamingDetailScreen> createState() => _GamingDetailScreenState();
}

class _GamingDetailScreenState extends ConsumerState<GamingDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final bool showGlows = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gamingMonitorProvider(widget.gameId).notifier).probeOnce(widget.gameId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gamingMonitorProvider(widget.gameId));
    final gameAsync = ref.watch(gameDetailProvider(widget.gameId));

    return Scaffold(
      backgroundColor: AppColors.background,
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          loading: () => const Text('Sondeando...', style: TextStyle(color: Colors.white)),
          error: (_, __) => const Text('Error', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: gameAsync.when(
        data: (game) {
          if (game == null || game.status == 'Esperando...') return const _ProbeView();
          return _ContentView(game: game, controller: _controller, showGlows: showGlows);
        },
        loading: () => const _ProbeView(),
        error: (err, __) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _ProbeView extends StatelessWidget {
  const _ProbeView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D285).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/gaming_pad.svg',
              width: 60,
              height: 60,
              colorFilter: const ColorFilter.mode(Color(0xFF00D285), BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 50),
          const SizedBox(
            width: 60,
            height: 60,
            child: LoadingIndicator(
              indicatorType: Indicator.ballScaleMultiple,
              colors: [Color(0xFF00D285), Colors.white],
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Sondeando mejores servidores...',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Calculando latencia optimizada para tu región',
            style: TextStyle(color: AppColors.textBody, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final Game game;
  final AnimationController controller;
  final bool showGlows;

  const _ContentView({required this.game, required this.controller, required this.showGlows});

  Color _statusColor(String status) {
    switch (status) {
      case 'Excelente': return const Color(0xFF00D285);
      case 'Muy Bueno': return const Color.fromARGB(255, 128, 255, 89);
      case 'Bueno': return Colors.amber;
      case 'Regular': return Colors.orange;
      case 'Malo':
      case 'Sin Conexión': return Colors.redAccent;
      case 'Esperando...': return Colors.grey;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(game.status);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) => RepaintBoundary(
                        child: CustomPaint(
                          painter: _RadarPainter(controller.value, statusColor),
                          size: const Size(280, 280),
                        ),
                      ),
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
                                  color: Colors.white, fontSize: 86, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ms',
                              style: TextStyle(
                                  color: statusColor, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text(
                          'LATENCIA',
                          style: TextStyle(
                              color: AppColors.textBody,
                              fontSize: 16,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetricColumn(label: 'Pérdida', value: game.loss, dividerColor: statusColor, isDivider: true),
                    _MetricColumn(label: 'Jitter', value: game.jitter, dividerColor: statusColor, isDivider: true),
                    _MetricColumn(label: 'Estado', value: game.status, valueColor: statusColor),
                  ],
                ),
                const SizedBox(height: 60),
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
                          Icon(Icons.dns, color: statusColor, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'SERVIDOR',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(game.serverName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(game.serverLocation,
                          style: const TextStyle(color: AppColors.textBody, fontSize: 14)),
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
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isDivider;
  final Color valueColor;
  final Color? dividerColor;

  const _MetricColumn({
    required this.label,
    required this.value,
    this.isDivider = false,
    this.valueColor = Colors.white,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                const SizedBox(height: 8),
                Text(value,
                    style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (isDivider)
            Container(
              width: 1.5,
              height: 35,
              color: dividerColor ?? const Color(0xFF00D285),
            ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _RadarPainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 2;
    for (int i = 0; i < 3; i++) {
      final value = (animationValue + i / 3) % 1.0;
      final radius = (size.width / 2) * value;
      paint.color = color.withOpacity(1.0 - value);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.animationValue != animationValue || old.color != color;
}
