import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/core/domain/entities/tools/servidor_juego.dart';
import 'package:tvapp/ui/providers/tools/gaming_server_providers.dart';
import 'package:tvapp/ui/providers/tools/gaming_monitor_service.dart';

class GamingDetailScreen extends ConsumerStatefulWidget {
  static const String name = 'Gaming Detail';

  final String gameId;
  const GamingDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamingDetailScreen> createState() => _GamingDetailScreenState();
}

class _GamingDetailScreenState extends ConsumerState<GamingDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  Color _statusColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'EXCELENTE':
        return const Color(0xFF00D285);
      case 'BUENO':
        return const Color(0xFF7B61FF);
      case 'MALO':
        return const Color(0xFFF44336);
      default:
        return AppColors.textBody;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gamingMonitorProvider(widget.gameId));
    final servidoresAsync = ref.watch(servidoresJuegoStreamProvider);

    return servidoresAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      ),
      data: (servidores) {
        final ServidorJuego? servidor = servidores.cast<ServidorJuego?>().firstWhere(
              (s) => s?.id == widget.gameId,
              orElse: () => null,
            );

        if (servidor == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.canPop() ? context.pop() : context.go('/'),
              ),
            ),
            body: const Center(
              child: Text('Servidor no encontrado', style: TextStyle(color: Colors.white)),
            ),
          );
        }

        final statusColor = _statusColor(servidor.estado);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                expandedHeight: 200,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.canPop() ? context.pop() : context.go('/'),
                ),
                title: Text(
                  servidor.juego,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [statusColor.withOpacity(0.3), AppColors.background],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _radarController,
                        builder: (context, child) => CustomPaint(
                          size: const Size(160, 160),
                          painter: _RadarPainter(_radarController.value, statusColor),
                          child: child,
                        ),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: statusColor, width: 2),
                          ),
                          child: Icon(Icons.sports_esports, color: statusColor, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${servidor.pingMs}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 86,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'ms',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'LATENCIA',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 16,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MetricColumn(
                          label: 'Pérdida',
                          value: '${servidor.perdidaPaquetesPct.toStringAsFixed(1)}%',
                          dividerColor: statusColor,
                          isDivider: true,
                        ),
                        _MetricColumn(
                          label: 'Jitter',
                          value: '${servidor.jitterMs} ms',
                          dividerColor: statusColor,
                          isDivider: true,
                        ),
                        _MetricColumn(
                          label: 'Estado',
                          value: servidor.estado,
                          valueColor: statusColor,
                        ),
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
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            servidor.servidor,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            servidor.ubicacion,
                            style: const TextStyle(color: AppColors.textBody, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
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
                Text(
                  label,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
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
