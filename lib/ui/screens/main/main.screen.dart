import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/config/router/event_notification_router.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/screens/home/home.screen.dart';
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

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ProfileSheet(
        onLogout: () {
          Navigator.pop(ctx);
          _logout();
        },
      ),
    );
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
      backgroundColor: const Color(0xFF1E1E32),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _AppBar(onProfileTap: _showProfileSheet),
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
            Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
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

class _ServicesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.85,
      children: [
        _HubServiceCard(
          svgAsset: AppAssets.hubEventos,
          title: 'Eventos',
          subtitle: 'Deportes, conciertos y mas...',
          onTap: () {},
        ),
        _HubServiceCard(
          svgAsset: AppAssets.hubTv,
          title: 'IPTV',
          subtitle: 'Canales para todos',
          onTap: () => context.pushNamed(HomeScreen.name),
        ),
        _HubServiceCard(
          svgAsset: AppAssets.hubPlay,
          title: 'VOD',
          subtitle: 'Entretenimiento',
          onTap: () {},
        ),
        _HubServiceCard(
          svgAsset: AppAssets.hubShieldCam,
          title: 'Cámaras',
          subtitle: 'Cuida tu hogar y a los tuyos',
          onTap: () => context.pushNamed('CamerasScreen'),
        ),
        _HubServiceCard(
          svgAsset: AppAssets.hubDescuento,
          title: 'Club de descuentos',
          subtitle: 'Restaurantes, tiendas y retail',
          isNew: true,
          onTap: () {},
        ),
        _HubServiceCard(
          svgAsset: AppAssets.hubCheckHealth,
          title: 'Check Health',
          subtitle: 'Revisa el estado de tu WIFI',
          isHealth: true,
          onTap: () => context.pushNamed(CheckHealthScreen.name),
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

class _ProfileSheet extends StatelessWidget {
  final VoidCallback onLogout;

  const _ProfileSheet({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.container,
            child: Icon(Icons.person_outline, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 28),
          const Divider(color: Color(0xFF2E2E42), height: 1),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: AppColors.error, size: 20),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
