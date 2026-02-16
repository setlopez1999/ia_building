import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({super.key});

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen>
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
          context.pushReplacement('/asistencia_problem');
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
          'Asistencia',
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
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 20,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.white12,
                      color: const Color.fromARGB(255, 173, 170, 203),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Diagnosticando....',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Verificando dispositivo...',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 40),
            _buildStepItem(
              'Verificando dispositivo',
              isDone: progress >= 0.25,
              isLoading: progress < 0.25,
            ),
            const SizedBox(height: 15),
            _buildStepItem(
              'Analizando Wifi',
              isDone: progress >= 0.5,
              isLoading: progress >= 0.25 && progress < 0.5,
            ),
            const SizedBox(height: 15),
            _buildStepItem(
              'Probando conectividad',
              isDone: progress >= 0.75,
              isLoading: progress >= 0.5 && progress < 0.75,
            ),
            const SizedBox(height: 15),
            _buildStepItem(
              'Detectando problemas',
              isDone: progress >= 0.95,
              isLoading: progress >= 0.75 && progress < 0.95,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(
    String title, {
    bool isDone = false,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (isDone)
            const Icon(Icons.check_circle, color: Color(0xFF00D285), size: 24)
          else if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: LoadingIndicator(
                indicatorType: Indicator.lineSpinFadeLoader,
                colors: [AppColors.textBody],
                strokeWidth: 2,
              ),
            )
          else
            const SizedBox(
              width: 20,
              height: 20,
              child: LoadingIndicator(
                indicatorType: Indicator.lineSpinFadeLoader,
                colors: [AppColors.textBody],
                strokeWidth: 2,
              ),
            ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
