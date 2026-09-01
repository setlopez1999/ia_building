import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/hub/hub_module_catalog.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/config/router/event_notification_router.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/hub/hub_modules_provider.dart';
import 'package:tvapp/ui/screens/account/account_screen.dart';
import 'package:tvapp/ui/screens/channels/channels_screen.widget.dart';
import 'package:tvapp/ui/screens/notifications/notifications.screen.dart';
import 'package:tvapp/ui/screens/tools/cameras/cameras_screen.dart';
import 'package:tvapp/ui/screens/tools/check_health/check_health_screen.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';

/// Pantalla principal post-login.
/// Grid de servicios: Eventos, IPTV, VOD, Cámaras, Club de descuentos, Check Health.
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  static const String name = 'Main';
  static const String path = '/main';

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  /// El avatar abre Mi cuenta directamente. Antes abría un panel con dos
  /// opciones, pero "Cerrar sesión" ya vive dentro de Mi cuenta.
  void _openAccount() {
    context.pushNamed(MyAccountScreen.name);
  }

  void _logout() {
    ref.read(authProvider.notifier).logout();
  }

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.container,
        title: const Text('¿Cerrar sesión?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('¿Deseas salir de tu cuenta?', style: TextStyle(color: AppColors.textBody)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textBody)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EventNotificationRouter.tryOpen();
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLogout = await _showLogoutDialog();
        if (shouldLogout == true && mounted) _logout();
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _AppBar(onProfileTap: _openAccount),
              const SizedBox(height: 30),
              const Text(
                '¡Bienvenido!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _BannerCarousel(
                currentIndex: _currentBannerIndex,
                controller: _bannerController,
                onPageChanged: (i) => setState(() => _currentBannerIndex = i),
              ),
              const SizedBox(height: 30),
              const Text(
                'Mis productos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _ServicesGrid(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  const _AppBar({required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          AppAssets.logoOneplay,
          height: 25,
          fit: BoxFit.contain,
        ),
        Row(
          children: [
            // Oculto: el backend todavia no manda señales de notificacion, y
            // el badge rojo fijo hacia creer que habia mensajes sin leer.
            if (Environment.notificationsEnabled) ...[
              GestureDetector(
                onTap: () => context.pushNamed(NotificationsScreen.name),
                child: const Icon(Icons.notifications_none,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
            ],
            GestureDetector(
              onTap: onProfileTap,
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.container,
                child: Icon(Icons.person_outline, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  final int currentIndex;
  final PageController controller;
  final void Function(int) onPageChanged;

  const _BannerCarousel({
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
  });

  static const _banners = [
    'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: _banners.length,
            itemBuilder: (ctx, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(_banners[index]),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.success
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicesGrid extends ConsumerWidget {
  const _ServicesGrid();

  void _openModule(BuildContext context, HubModuleId id) {
    switch (id) {
      case HubModuleId.iptv:
        // Entra directo a canales: el home antiguo y su barra inferior
        // quedan fuera del flujo del modulo IPTV.
        context.pushNamed(ChannelsScreen.name);
      case HubModuleId.camaras:
        context.pushNamed(CamerasScreen.name);
      case HubModuleId.checkHealth:
        context.pushNamed(CheckHealthScreen.name);
      case HubModuleId.eventos || HubModuleId.vod || HubModuleId.clubDescuentos:
        // Todavia sin pantalla. Un tap que no hace nada se lee como que la
        // app esta rota; conviene decir que el modulo esta por venir.
        _avisarProximamente(context, id);
    }
  }

  void _avisarProximamente(BuildContext context, HubModuleId id) {
    final nombre = HubModuleCatalog.all
        .firstWhere((m) => m.id == id,
            orElse: () => HubModuleCatalog.all.first)
        .title;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.container,
          behavior: SnackBarBehavior.floating,
          content: Text(
            '$nombre estara disponible proximamente.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(hubModulesProvider);

    // Regla 1: si no hay modulos hay que decirlo. Antes devolvia un
    // SizedBox.shrink() y quedaba el titulo "Mis productos" sobre un vacio,
    // sin forma de saber si estaba cargando, si fallo o si no hay nada.
    if (modules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          children: [
            Icon(Icons.widgets_outlined, color: Colors.white38, size: 40),
            SizedBox(height: 12),
            Text(
              'No tienes productos disponibles.\n'
              'Comunicate con tu operador si crees que es un error.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.85,
      children: [
        for (final module in modules)
          _HubServiceCard(
            svgAsset: module.svgAsset,
            title: module.title,
            subtitle: module.subtitle,
            isNew: module.isNew,
            isHealth: module.isHealth,
            onTap: () => _openModule(context, module.id),
          ),
      ],
    );
  }
}

class _HubServiceCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isNew;
  final bool isHealth;

  const _HubServiceCard({
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isNew = false,
    this.isHealth = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E42),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    svgAsset,
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB0B0C3),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            if (isNew)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Nuevo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

