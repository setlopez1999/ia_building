import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/shared/utils/list_type.enum.dart';
import 'package:tvapp/ui/shared/widgets/channel_list_type_button.dart';
import 'package:tvapp/ui/shared/widgets/app_input.widget.dart';

class CamerasScreen extends ConsumerStatefulWidget {
  static const name = 'CamerasScreen';

  const CamerasScreen({super.key});

  @override
  ConsumerState<CamerasScreen> createState() => _CamerasScreenState();
}

class _CamerasScreenState extends ConsumerState<CamerasScreen> {
  ListType listType = ListType.list;
  bool _searching = false;
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(cameraListProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  /// Filtra solo por nombre, sin distinguir mayusculas ni acentos del query.
  List<CameraEntity> _filter(List<CameraEntity> cameras) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return cameras;
    return cameras
        .where((camera) => camera.name.toLowerCase().contains(q))
        .toList();
  }

  void _openCamera(CameraEntity camera) {
    ref.read(cameraSelectedProvider.notifier).select(camera);
    context.push('/tools/cameras/player', extra: camera);
  }

  @override
  Widget build(BuildContext context) {
    final camerasAsync = ref.watch(cameraListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámaras'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(_searching ? Icons.close : Icons.search),
            tooltip: _searching ? 'Cerrar búsqueda' : 'Buscar',
          ),
        ],
        // Regla 3: el buscador usa el input compartido, igual que el de IPTV.
        bottom: _searching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: AppSearchInput(
                    controller: _searchController,
                    hint: 'Buscar cámara por nombre',
                    autofocus: true,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
              )
            : null,
      ),
      backgroundColor: AppColors.background,
      body: camerasAsync.when(
        data: (cameras) {
          if (cameras.isEmpty) {
            return const _EmptyMessage('No tienes cámaras disponibles');
          }

          final filtered = _filter(cameras);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 4),
                child: ChannelListTypeButton(
                  listType: listType,
                  onPressed: () {
                    setState(() {
                      listType = listType == ListType.list
                          ? ListType.grid
                          : ListType.list;
                    });
                  },
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyMessage('Ninguna cámara coincide con "$_query"')
                    : listType == ListType.list
                        ? _CamerasList(cameras: filtered, onTap: _openCamera)
                        : _CamerasGrid(cameras: filtered, onTap: _openCamera),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.amber)),
        error: (e, _) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                'Error al cargar cámaras',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontSize: 16),
        ),
      ),
    );
  }
}

class _CamerasList extends StatelessWidget {
  const _CamerasList({required this.cameras, required this.onTap});

  final List<CameraEntity> cameras;
  final void Function(CameraEntity) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cameras.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final camera = cameras[index];
        return _CameraCard(camera: camera, onTap: () => onTap(camera));
      },
    );
  }
}

class _CamerasGrid extends StatelessWidget {
  const _CamerasGrid({required this.cameras, required this.onTap});

  final List<CameraEntity> cameras;
  final void Function(CameraEntity) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: cameras.length,
      itemBuilder: (context, index) {
        final camera = cameras[index];
        return _CameraGridCard(camera: camera, onTap: () => onTap(camera));
      },
    );
  }
}

class _CameraCard extends StatelessWidget {
  final CameraEntity camera;
  final VoidCallback onTap;

  const _CameraCard({required this.camera, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.videocam, color: Colors.amber, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camera.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Serial: ${camera.serial}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill, color: Colors.amber, size: 32),
          ],
        ),
      ),
    );
  }
}

class _CameraGridCard extends StatelessWidget {
  const _CameraGridCard({required this.camera, required this.onTap});

  final CameraEntity camera;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.videocam, color: Colors.amber, size: 34),
            ),
            const SizedBox(height: 12),
            Text(
              camera.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              camera.serial,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
