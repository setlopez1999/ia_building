import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrandingConfig {

  const BrandingConfig({
    this.colorGradient1 = const Color(0xFF00CC66),
    this.colorGradient2 = const Color(0xFF004E92),
  });
  final Color colorGradient1;
  final Color colorGradient2;
}

final brandingProvider = Provider<BrandingConfig>((ref) {
  return const BrandingConfig();
});
