import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../data/models/dispositivo.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  String _svgForTipo(String tipo) {
    switch (tipo) {
      case 'smartphone':
        return 'assets/smartphone.svg';
      case 'laptop':
        return 'assets/laptop.svg';
      case 'pc':
        return 'assets/pc.svg';
      case 'router':
        return 'assets/router.svg';
      default:
        return 'assets/smartphone.svg';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispositivosAsync = ref.watch(dispositivosProvider);

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
        child: dispositivosAsync.when(
          data: (dispositivos) {
            final conectados =
                dispositivos.where((d) => d.conectado).length;
            return Column(
              children: [
                const SizedBox(height: 10),
                _buildMainHeader(conectados, dispositivos.length),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                    itemCount: dispositivos.length,
                    itemBuilder: (context, index) {
                      final d = dispositivos[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < dispositivos.length - 1 ? 15 : 0,
                        ),
                        child: _buildDeviceItem(
                          name: d.nombre,
                          status: d.conectado ? 'Conectado' : 'Desconectado',
                          isConnected: d.conectado,
                          svgAsset: _svgForTipo(d.tipo),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D285)),
          ),
          error: (err, _) => Center(
            child: Text(
              'Error al cargar dispositivos',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader(int conectados, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFF00D285),
            child: Icon(Icons.check, color: Colors.white, size: 45),
          ),
          const SizedBox(height: 25),
          Text(
            '$conectados dispositivos\nconectados',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            total > 0
                ? 'Total: $total dispositivos en la red'
                : 'Tu conexión está funcionando perfectamente',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textBody, fontSize: 13),
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
