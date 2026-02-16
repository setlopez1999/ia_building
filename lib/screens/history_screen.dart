import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          'Historial',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de diagnósticos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildTimelineItem(
              status: 'Excelente',
              color: const Color(0xFF00D285),
              time: 'Hoy, 14:28',
              metrics: 'Velocidad: 248 Mbps - Latencia: 12 ms',
              isLast: false,
            ),
            _buildTimelineItem(
              status: 'Bueno',
              color: const Color(0xFF2196F3),
              time: 'Hoy, 14:28',
              metrics: 'Velocidad: 248 Mbps - Latencia: 12 ms',
              isLast: false,
            ),
            _buildTimelineItem(
              status: 'Regular',
              color: const Color(0xFFFF9800),
              time: 'Hoy, 14:28',
              metrics: 'Velocidad: 248 Mbps - Latencia: 12 ms',
              isLast: false,
            ),
            _buildTimelineItem(
              status: 'Malo',
              color: const Color(0xFFF44336),
              time: 'Hoy, 14:28',
              metrics: 'Velocidad: 248 Mbps - Latencia: 12 ms',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String status,
    required Color color,
    required String time,
    required String metrics,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.white24)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF32324A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              color: Color(0xFF7B61FF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        metrics,
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Ver detalles',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
