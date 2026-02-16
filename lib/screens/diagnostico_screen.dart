import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../utils/app_colors.dart';

class DiagnosticoScreen extends StatefulWidget {
  const DiagnosticoScreen({super.key});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.pushReplacement('/diagnostico_result');
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _animation.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text(
          'Diagnóstico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 30,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.white12,
                      color: const Color.fromARGB(255, 173, 170, 203),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 173, 170, 203),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Analizando velocidad\n de internet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const SizedBox(height: 50),
            _buildStatusItem(
              'Velocidad de internet',
              progress >= 0.25
                  ? 'Descarga: 248 Mbps / Carga: 95 Mbps'
                  : 'Analizando...',
              isDone: progress >= 0.25,
              isLoading: progress < 0.25,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Red Wifi Doméstica',
              progress >= 0.5 ? 'Señal estable' : 'Esperando...',
              isDone: progress >= 0.5,
              isLoading: progress >= 0.25 && progress < 0.5,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Fibra óptica',
              progress >= 0.75 ? 'Potencia óptima' : 'Esperando...',
              isDone: progress >= 0.75,
              isLoading: progress >= 0.5 && progress < 0.75,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Latencia y estabilidad',
              progress >= 0.95 ? '12ms (Excelente)' : 'Esperando...',
              isDone: progress >= 0.95,
              isLoading: progress >= 0.75 && progress < 0.95,
            ),
            const Spacer(),
            _buildCancelButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    String title,
    String subtitle, {
    required bool isDone,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: isDone || isLoading
            ? Border.all(
                color: isDone ? const Color(0xFF00D285) : AppColors.textBody,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: isDone
                ? const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00D285),
                    size: 24,
                  )
                : isLoading
                ? const LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: [AppColors.textBody],
                    strokeWidth: 2,
                  )
                : Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.textBody,
                    ),
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDone
                        ? const Color(0xFF00D285)
                        : isLoading
                        ? const Color.fromARGB(255, 164, 164, 223)
                        : AppColors.textBody,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle, color: Color(0xFF00D285), size: 18),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF44336).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'Cancelar diagnóstico',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
