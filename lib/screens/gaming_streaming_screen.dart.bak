import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

class GamingStreamingScreen extends StatefulWidget {
  const GamingStreamingScreen({super.key});

  @override
  State<GamingStreamingScreen> createState() => _GamingStreamingScreenState();
}

class _GamingStreamingScreenState extends State<GamingStreamingScreen> {
  bool isGamingExpanded = true;
  bool isStreamingExpanded = true;

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
          'Gaming & Streaming',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF00D285),
                child: Icon(Icons.check, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Conexión buena',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Ideal para gaming casual y streaming HD',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildOverallPerformanceCard(),
            const SizedBox(height: 20),
            _buildCategoryCard(
              'Gaming',
              'Latencia en tiempo real a servidores sudamericanos',
              'assets/gaming_pad.svg',
              isGamingExpanded,
              () => setState(() => isGamingExpanded = !isGamingExpanded),
              const [
                _GameItem(
                  'Riot Games',
                  '25',
                  'Excelente',
                  'assets/logos/logo_riot.png',
                ),
                _GameItem(
                  'Valve',
                  '39',
                  'Excelente',
                  'assets/logos/logo_valve.png',
                ),
                _GameItem(
                  'Epic Games',
                  '36',
                  'Excelente',
                  'assets/logos/logo_epic_games.png',
                ),
                _GameItem(
                  'Activision',
                  '22',
                  'Excelente',
                  'assets/logos/logo_activision.png',
                ),
                _GameItem(
                  'EA Sports',
                  '46',
                  'Excelente',
                  'assets/logos/logo_ea.png',
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildSimpleCategoryCard(
              'Streaming',
              'Rendimiento para transmisión en vivo',
              'assets/streaming.svg',
              isStreamingExpanded,
              () => setState(() => isStreamingExpanded = !isStreamingExpanded),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF00D285),
            child: Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rendimiento de tu conexión para juegos y streaming',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMiniMetric('Pint promedio', '26 ms'),
                    _buildMiniMetric('Jitter', '11 ma'),
                    _buildMiniMetric('Perdida de paquetes', '0.0% ma'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value) {
    return Column(
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
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    String iconPath,
    bool isExpanded,
    VoidCallback onToggle,
    List<_GameItem> items,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textBody,
                    BlendMode.srcIn,
                  ),
                  width: 40,
                  height: 40,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 20),
            ...items.map((item) => _buildGameRow(item)),
          ],
        ],
      ),
    );
  }

  Widget _buildGameRow(_GameItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Image.asset(
              item.logoPath,
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Valorant / LOL',
                  style: TextStyle(color: AppColors.textBody, fontSize: 11),
                ),
                const Text(
                  'LAS 1',
                  style: TextStyle(color: AppColors.textBody, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.ping,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.status,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCategoryCard(
    String title,
    String subtitle,
    String iconPath,
    bool isExpanded,
    VoidCallback onToggle,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textBody,
                    BlendMode.srcIn,
                  ),
                  width: 40,
                  height: 40,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameItem {
  final String name;
  final String ping;
  final String status;
  final String logoPath;

  const _GameItem(this.name, this.ping, this.status, this.logoPath);
}
