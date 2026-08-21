import 'package:shared_preferences/shared_preferences.dart';

class PlayerBrightness {
  final _prefs = SharedPreferences.getInstance();

  Future<void> saveBrightness(double brightness) async {
    final prefs = await _prefs;
    await prefs.setDouble('sp_screen_brightness', brightness);
  }

  Future<double> loadBrightness() async {
    final prefs = await _prefs;
    return prefs.getDouble('sp_screen_brightness') ?? 1;
  }
}