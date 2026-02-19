import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../utils/app_colors.dart';

class ServiceLoadingScreen extends StatefulWidget {
  final String targetPath;

  const ServiceLoadingScreen({super.key, required this.targetPath});

  @override
  State<ServiceLoadingScreen> createState() => _ServiceLoadingScreenState();
}

class _ServiceLoadingScreenState extends State<ServiceLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a premium loading delay before navigating to the actual service
    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.pushReplacement(widget.targetPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Oneplay Logo prominently in the center
            SvgPicture.asset(
              'assets/hub/logo_oneplay.svg',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 60),
            // High-quality loading indicator
            const SizedBox(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: [Color(0xFF00D285), Colors.white],
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Iniciando servicio...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getServiceLabel(),
              style: const TextStyle(color: AppColors.textBody, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _getServiceLabel() {
    if (widget.targetPath.contains('check_health')) return 'Check Health';
    if (widget.targetPath.contains('gaming')) return 'Gaming Center';
    if (widget.targetPath.contains('streaming')) return 'Streaming Hub';
    return 'Oneplay Service';
  }
}
