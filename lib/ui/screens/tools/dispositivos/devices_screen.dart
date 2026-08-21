import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/dispositivos_providers.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';

class DevicesScreen extends ConsumerWidget {
  static const String name = 'Devices';

  const DevicesScreen({super.key});

  String _svgForTipo(String tipo) {
    switch (tipo) {
      case 'smartphone': return AppAssets.toolsSmartphone;
      case 'laptop': return AppAssets.toolsLaptop;
      case 'pc': return AppAssets.toolsPc;
      case 'router': return AppAssets.toolsRouter;
      default: return AppAssets.toolsSmartphone;
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
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
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
            final conectados = dispositivos.where((d) => d.conectado).length;
            return Column(
              children: [
                const SizedBox(height: 10),
                _DevicesHeader(conectados: conectados, total: dispositivos.length),
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
                        child: _DeviceItem(
                          nombre: d.nombre,
                          conectado: d.conectado,
                          svgAsset: _svgForTipo(d.tipo),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.success)),
          error: (err, _) => const Center(
            child: Text('Error al cargar dispositivos', style: TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}

class _DevicesHeader extends StatelessWidget {
  final int conectados;
  final int total;
  const _DevicesHeader({required this.conectados, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.success,
            child: Icon(Icons.check, color: Colors.white, size: 45),
          ),
          const SizedBox(height: 25),
          Text(
            '$conectados dispositivos\nconectados',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            total > 0 ? 'Total: $total dispositivos en la red' : 'Tu conexión está funcionando perfectamente',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textBody, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DeviceItem extends StatelessWidget {
  final String nombre;
  final bool conectado;
  final String svgAsset;

  const _DeviceItem({required this.nombre, required this.conectado, required this.svgAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            svgAsset,
            colorFilter: const ColorFilter.mode(AppColors.success, BlendMode.srcIn),
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  conectado ? 'Conectado' : 'Desconectado',
                  style: TextStyle(
                    color: conectado ? AppColors.success : Colors.white30,
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
