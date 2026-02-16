import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class DiagnosticoResultScreen extends StatelessWidget {
  const DiagnosticoResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSuccessCard(),
            const SizedBox(height: 20),
            _buildResultDetailCard(
              'Velocidad de internet',
              'Descarga',
              '248 Mbps',
              'Carga',
              '95 Mbps',
              '9.5/10',
            ),
            const SizedBox(height: 15),
            _buildResultDetailCard(
              'Red Wifi',
              'Señal',
              '-45 dBm',
              'Canal',
              '5 GHz',
              '9.5/10',
            ),
            const SizedBox(height: 15),
            _buildResultDetailCard(
              'Fibra óptica',
              'Potencia',
              '-18 dBm',
              'Estado',
              'Optimo',
              '9.5/10',
            ),
            const SizedBox(height: 15),
            _buildResultDetailCard(
              'Latencia',
              'Potencia',
              '-18 dBm',
              'Estado',
              'Optimo',
              '9.5/10',
            ),
            const SizedBox(height: 25),
            _buildRecommendationsCard(),
            const SizedBox(height: 30),
            _buildNewDiagnosticButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF00D285),
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'Excelente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Tu conexión está funcionando perfectamente',
            style: TextStyle(color: AppColors.textBody, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetailCard(
    String title,
    String label1,
    String val1,
    String label2,
    String val2,
    String score,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF00D285),
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
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
              Text(
                score,
                style: const TextStyle(
                  color: Color(0xFF00D285),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildDetailItem(label1, val1),
              _buildDetailItem(label2, val2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textBody, fontSize: 11),
          ),
          Text(
            value,
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

  Widget _buildRecommendationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recomendaciones',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Optimiza tu WIFI',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            'Tienes 8 dispositivos conectados. Considera desconectar los que no uses.',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
          SizedBox(height: 20),
          Text(
            'Ubicación',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            'Tu señal WIFI podría mejorar reubicando el router en un lugar central.',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNewDiagnosticButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pushReplacement('/diagnostico'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF00D285),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Nuevo diagnóstico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
