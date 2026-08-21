import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';

// deprecated — use gaming_screen + streaming_screen individually
class GamingStreamingScreen extends StatefulWidget {
  static const String name = 'Gaming Streaming';

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
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: const Text('Gaming & Streaming',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            const Text('Conexión buena',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Ideal para gaming casual y streaming HD',
                style: TextStyle(color: AppColors.textBody, fontSize: 13)),
            const SizedBox(height: 20),
            _CategoryCard(
              title: 'Gaming',
              subtitle: 'Latencia en tiempo real a servidores sudamericanos',
              iconPath: 'assets/tools/gaming_pad.svg',
              isExpanded: isGamingExpanded,
              onToggle: () => setState(() => isGamingExpanded = !isGamingExpanded),
            ),
            const SizedBox(height: 15),
            _CategoryCard(
              title: 'Streaming',
              subtitle: 'Rendimiento para transmisión en vivo',
              iconPath: 'assets/tools/streaming.svg',
              isExpanded: isStreamingExpanded,
              onToggle: () => setState(() => isStreamingExpanded = !isStreamingExpanded),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF32324A), borderRadius: BorderRadius.circular(25)),
      child: InkWell(
        onTap: onToggle,
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(AppColors.textBody, BlendMode.srcIn),
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textBody, fontSize: 11)),
                ],
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.textBody,
            ),
          ],
        ),
      ),
    );
  }
}
