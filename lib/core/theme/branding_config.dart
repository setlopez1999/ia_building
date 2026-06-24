import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

class BrandingConfig {
  final Color colorGradient1;
  final Color colorGradient2;
  final String logoAssetPath;

  const BrandingConfig({
    required this.colorGradient1,
    required this.colorGradient2,
    required this.logoAssetPath,
  });
}

final brandingProvider = FutureProvider<BrandingConfig>((ref) async {
  try {
    final raw = await rootBundle.loadString('assets/branding.env');
    final vars = _parseEnv(raw);
    return BrandingConfig(
      colorGradient1: _parseHexColor(vars['COLOR_GRADIENT_1'] ?? AppConstants.colorGradient1),
      colorGradient2: _parseHexColor(vars['COLOR_GRADIENT_2'] ?? AppConstants.colorGradient2),
      logoAssetPath: '${vars['LOGO_ASSET'] ?? AppConstants.logoAsset}.svg',
    );
  } catch (_) {
    return BrandingConfig(
      colorGradient1: _parseHexColor(AppConstants.colorGradient1),
      colorGradient2: _parseHexColor(AppConstants.colorGradient2),
      logoAssetPath: '${AppConstants.logoAsset}.svg',
    );
  }
});

Map<String, String> _parseEnv(String raw) {
  final map = <String, String>{};
  for (final line in raw.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final eq = trimmed.indexOf('=');
    if (eq == -1) continue;
    map[trimmed.substring(0, eq).trim()] = trimmed.substring(eq + 1).trim();
  }
  return map;
}

Color _parseHexColor(String hex) {
  final h = hex.replaceFirst('#', '');
  final fullHex = h.length == 6 ? 'FF$h' : h;
  return Color(int.parse(fullHex, radix: 16));
}
