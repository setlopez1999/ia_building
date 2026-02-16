import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

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
          'Dispositivos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildMainHeader(),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                children: [
                  _buildDeviceItem(
                    name: 'Samsung S23',
                    status: 'Conectado',
                    isConnected: true,
                    svgAsset: 'assets/smartphone.svg',
                  ),
                  const SizedBox(height: 15),
                  _buildDeviceItem(
                    name: 'Samsung A40',
                    status: 'Conectado',
                    isConnected: true,
                    svgAsset: 'assets/smartphone.svg',
                  ),
                  const SizedBox(height: 15),
                  _buildDeviceItem(
                    name: 'Motorola 45-8',
                    status: 'Conectado',
                    isConnected: true,
                    svgAsset: 'assets/smartphone.svg',
                  ),
                  const SizedBox(height: 15),
                  _buildDeviceItem(
                    name: 'MacBook Pro',
                    status: 'Conectado',
                    isConnected: true,
                    svgAsset: 'assets/laptop.svg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFF00D285),
            child: Icon(Icons.check, color: Colors.white, size: 45),
          ),
          SizedBox(height: 25),
          Text(
            '4 dispositivos\nconectados',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tu conexión está funcionando perfectamente',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textBody, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem({
    required String name,
    required String status,
    required bool isConnected,
    required String svgAsset,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            svgAsset,
            colorFilter: const ColorFilter.mode(
              Color(0xFF00D285),
              BlendMode.srcIn,
            ),
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: isConnected
                        ? const Color(0xFF00D285)
                        : Colors.white30,
                    fontSize: 13,
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
